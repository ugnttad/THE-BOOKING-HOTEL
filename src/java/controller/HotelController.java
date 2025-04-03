package controller;

import dao.HotelDAO;
import dao.RoomDAO;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Hotel;
import model.Room;
import com.fasterxml.jackson.databind.ObjectMapper;
import javax.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "HotelController", urlPatterns = {"/hotels", "/search-hotels", "/filter-hotels", "/hotel-details"})
public class HotelController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        if ("/hotel-details".equals(action)) {
            getHotelDetails(request, response);
        } else {
            handleHotelsPage(request, response);
        }
    }

    private void handleHotelsPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchParam = request.getParameter("search");
        HttpSession session = request.getSession();
        HotelDAO hotelDAO = new HotelDAO();
        List<Hotel> hotelList;

        // Lấy user từ session để kiểm tra đăng nhập
        User user = (User) session.getAttribute("user"); // Giả sử User là model người dùng trong session
        int userId = (user != null) ? user.getUserId() : -1; // -1 nếu chưa đăng nhập

        if ("true".equals(searchParam)) {
            hotelList = (List<Hotel>) session.getAttribute("hotelList");
            session.removeAttribute("hotelList");
            if (hotelList == null) {
                response.sendRedirect(request.getContextPath() + "/hotels");
                return;
            }
        } else {
            hotelList = hotelDAO.getAllActiveHotels(userId);
        }

        request.setAttribute("hotelList", hotelList);
        request.getRequestDispatcher("/pages/hotel-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        if ("/filter-hotels".equals(action)) {
            filterHotels(request, response);
        } else {
            searchHotels(request, response);
        }
    }

    private void searchHotels(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String location = request.getParameter("location");
            String checkInStr = request.getParameter("checkin");
            String checkOutStr = request.getParameter("checkout");
            String guestsStr = request.getParameter("guests");
            String roomsStr = request.getParameter("rooms");

            if (location == null || checkInStr == null || checkOutStr == null
                    || guestsStr == null || roomsStr == null
                    || location.isEmpty() || checkInStr.isEmpty() || checkOutStr.isEmpty()
                    || guestsStr.isEmpty() || roomsStr.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters.");
                return;
            }

            int guests = Integer.parseInt(guestsStr);
            int rooms = Integer.parseInt(roomsStr);

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            java.sql.Date checkIn = new java.sql.Date(sdf.parse(checkInStr).getTime());
            java.sql.Date checkOut = new java.sql.Date(sdf.parse(checkOutStr).getTime());

            HotelDAO hotelDAO = new HotelDAO();
            List<Hotel> hotels = hotelDAO.searchHotels(location, checkIn, checkOut, guests, rooms);

            request.getSession().setAttribute("hotelList", hotels);
            response.sendRedirect(request.getContextPath() + "/hotels?search=true");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid number format for guests or rooms.");
        } catch (ParseException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid date format.");
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error.");
        } catch (Exception ex) {
            Logger.getLogger(HotelController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private void filterHotels(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String hotelName = request.getParameter("hotelName");
            String[] roomTypesArray = request.getParameterValues("roomType");
            String[] facilitiesArray = request.getParameterValues("facilities");
            String[] mealPlansArray = request.getParameterValues("mealPlans");
            String minRatingStr = request.getParameter("minRating");

            // Chuyển đổi String[] thành String (chuỗi phân tách bằng dấu phẩy)
            String roomTypes = (roomTypesArray != null) ? String.join(",", roomTypesArray) : null;
            System.out.println(roomTypes);
            String facilities = (facilitiesArray != null) ? String.join(",", facilitiesArray) : null;
            String mealPlans = (mealPlansArray != null) ? String.join(",", mealPlansArray) : null;

            Integer minRating = (minRatingStr != null && !minRatingStr.isEmpty()) ? Integer.parseInt(minRatingStr) : null;

            HotelDAO hotelDAO = new HotelDAO();
            List<Hotel> hotels = hotelDAO.filterHotels(hotelName, roomTypes, facilities, mealPlans, minRating);

            // Lưu danh sách khách sạn vào session và chuyển hướng đến /hotels
            request.getSession().setAttribute("hotelList", hotels);
            response.sendRedirect(request.getContextPath() + "/hotels?search=true");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing filter request.");
        }
    }

    private void getHotelDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String hotelIdStr = request.getParameter("hotelId");

            if (hotelIdStr == null || hotelIdStr.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing hotel ID.");
                return;
            }

            int hotelId = Integer.parseInt(hotelIdStr);
            HotelDAO hotelDAO = new HotelDAO();
            Hotel hotel = hotelDAO.getHotelById(hotelId);

            if (hotel == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Hotel not found.");
                return;
            }

            RoomDAO roomDAO = new RoomDAO();
            List<Room> rooms = roomDAO.getRoomsByHotelId(hotelId);

            request.setAttribute("hotel", hotel);

            ObjectMapper objectMapper = new ObjectMapper();
            List<String> imageUrls = objectMapper.readValue(hotel.getHotelImageURLs(), List.class);
            request.setAttribute("imageUrls", imageUrls);

            request.setAttribute("hotelRooms", rooms);
            request.getRequestDispatcher("/pages/hotel-details.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid hotel ID format.");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching hotel details.");
        }
    }
}
