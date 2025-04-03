package controller;

import dao.BookingDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import java.sql.SQLException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Booking;
import model.Room;
import model.User;

@MultipartConfig
@WebServlet(name = "BookingController", urlPatterns = {"/booking", "/process-checkout", "/check-room-availability", "/booking-list"})
public class BookingController extends HttpServlet {

    // Xử lý GET request cho /check-room-availability
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getRequestURI();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            switch (path) {
                case "/HotelBooking/check-room-availability" ->
                    checkRoomAvailability(request, response, out);
                case "/HotelBooking/booking-list" ->
                    getBookingsForUser(request, response);
                default -> {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            }
        } catch (Exception ex) {
            Logger.getLogger(BookingController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Xử lý POST request cho /booking
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy đường dẫn (path) để xác định hành động
        String path = request.getRequestURI();
        if (path.contains("/HotelBooking")) {
            path = path.split("/HotelBooking")[1];
        }

        switch (path) {
            case "/booking" ->
                bookRoom(request, response);
            case "/process-checkout" -> {
                try {
                    processCheckout(request, response);
                } catch (Exception ex) {
                    Logger.getLogger(BookingController.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            default -> {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        }
    }
    
    private void getBookingsForUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        HttpSession session = request.getSession();
        User user = (User)session.getAttribute("user");
        
        if (user == null) request.getRequestDispatcher("/").forward(request, response);

        try {
            List<Booking> bookings = new BookingDAO().getUserBookings(user.getUserId());
            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("/pages/my-booking.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving user bookings");
        }
    }

    // Hàm kiểm tra phòng có sẵn
    private void checkRoomAvailability(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
            throws IOException {
        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            String checkInDateStr = request.getParameter("checkInDate");
            String checkOutDateStr = request.getParameter("checkOutDate");

            // Automatically append '00:00:00' if the date does not have time
            checkInDateStr = appendTimeIfMissing(checkInDateStr);
            checkOutDateStr = appendTimeIfMissing(checkOutDateStr);

            // Call the method in DAO to check availability
            boolean isAvailable = new BookingDAO().checkRoomAvailability(roomId, checkInDateStr, checkOutDateStr);

            if (!isAvailable) {
                HttpSession session = request.getSession();
                Map<Integer, List<Room>> selectedRooms = (Map<Integer, List<Room>>) session.getAttribute("selectedRooms");

                if (selectedRooms != null) {
                    for (Map.Entry<Integer, List<Room>> entry : selectedRooms.entrySet()) {
                        List<Room> roomsForHotel = entry.getValue();
                        roomsForHotel.removeIf(room -> room.getRoomId() == roomId);
                        selectedRooms.put(entry.getKey(), roomsForHotel);
                    }
                    session.setAttribute("selectedRooms", selectedRooms);
                }
            }

            // Return the result as JSON
            out.print("{\"isAvailable\": " + isAvailable + "}");
        } catch (Exception e) {
            Logger.getLogger(BookingController.class.getName()).log(Level.SEVERE, null, e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Internal Server Error\"}");
        } finally {
            out.flush();
        }
    }

    // Helper function to append '00:00:00' to the date if time is missing
    private String appendTimeIfMissing(String dateStr) {
        if (dateStr != null && dateStr.length() == 10) {  // Date format is yyyy-MM-dd
            return dateStr + " 00:00:00";  // Append default time if missing
        }
        return dateStr;  // Return the date string as-is if time is already present
    }

    // Hàm xử lý đặt phòng
    private void bookRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int hotelId = Integer.parseInt(request.getParameter("hotelId"));
        HttpSession session = request.getSession();
        Map<Integer, List<Room>> selectedRooms = (Map<Integer, List<Room>>) session.getAttribute("selectedRooms");
        List<Room> selectedRoomsForCurrentHotel = selectedRooms != null ? selectedRooms.get(hotelId) : null;

        String checkInDateStr = request.getParameter("checkInDate");
        String checkOutDateStr = request.getParameter("checkOutDate");

        // Modify date handling to append '00:00:00' if the time component is missing
        checkInDateStr = appendTimeIfMissing(checkInDateStr);
        checkOutDateStr = appendTimeIfMissing(checkOutDateStr);

        // Use 'yyyy-MM-dd HH:mm:ss' format for parsing date with time
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date checkInDate = null;
        Date checkOutDate = null;

        try {
            if (checkInDateStr != null && !checkInDateStr.isEmpty()) {
                checkInDate = dateFormat.parse(checkInDateStr);
            }
            if (checkOutDateStr != null && !checkOutDateStr.isEmpty()) {
                checkOutDate = dateFormat.parse(checkOutDateStr);
            }
        } catch (ParseException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid date format");
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        double subTotal = 0;
        List<Integer> unavailableRooms = new ArrayList<>();

        if (selectedRoomsForCurrentHotel != null) {
            Iterator<Room> iterator = selectedRoomsForCurrentHotel.iterator();
            while (iterator.hasNext()) {
                Room room = iterator.next();
                boolean isAvailable;
                try {
                    // Check room availability based on the formatted date strings
                    isAvailable = bookingDAO.checkRoomAvailability(room.getRoomId(), checkInDateStr, checkOutDateStr);
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error checking room availability");
                    return;
                }

                if (!isAvailable) {
                    unavailableRooms.add(room.getRoomId());
                    iterator.remove();
                } else {
                    subTotal += room.getPricePerNight();
                }
            }
        }

        if (!unavailableRooms.isEmpty()) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print("{\"error\": \"Some rooms are unavailable\", \"unavailableRooms\": " + unavailableRooms + "}");
            out.flush();
            return;
        }

        if (selectedRoomsForCurrentHotel == null || selectedRoomsForCurrentHotel.isEmpty()) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "{\"error\": \"No available rooms for the selected dates\"}");
            return;
        }

        double bookingFees = 10;
        double amountToPay = subTotal + bookingFees;

        session.setAttribute("hotelId", hotelId);
        session.setAttribute("checkInDate", dateFormat.format(checkInDate)); // Format date with time
        session.setAttribute("checkOutDate", dateFormat.format(checkOutDate)); // Format date with time
        session.setAttribute("subTotal", subTotal);
        session.setAttribute("amountToPay", amountToPay);
        session.setAttribute("selectedRoomsForCurrentHotel", selectedRoomsForCurrentHotel);

        response.sendRedirect(request.getContextPath() + "/pages/hotel-booking.jsp");
    }

    private void processCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String checkInDate = request.getParameter("checkInDate");
        String checkOutDate = request.getParameter("checkOutDate");
        double total = Double.parseDouble(request.getParameter("total"));

        // Save checkout information in session
        session.setAttribute("checkInDate", checkInDate);
        session.setAttribute("checkOutDate", checkOutDate);
        session.setAttribute("firstName", firstName);
        session.setAttribute("lastName", lastName);
        session.setAttribute("email", email);
        session.setAttribute("phoneNumber", phoneNumber);
        session.setAttribute("total", total);

        // Redirect to vnpay_pay.jsp
        response.sendRedirect(request.getContextPath() + "/pages/payment/vnpay_pay.jsp");
    }
}
