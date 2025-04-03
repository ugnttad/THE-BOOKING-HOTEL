package controller.payment;

import dao.BookingDAO;
import dao.WalletDAO;
import config.VNPayConfig;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Room;
import model.User;

@WebServlet("/payment-result")
public class PaymentResult extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(PaymentResult.class.getName());
    private static final double EXCHANGE_RATE_VND_TO_USD = 25336.0;
    private static final BigDecimal ADMIN_BOOKING_FEE_USD = BigDecimal.valueOf(10); // $10 fee cho Admin
    private static final BigDecimal ADMIN_BOOKING_FEE_VND = ADMIN_BOOKING_FEE_USD.multiply(BigDecimal.valueOf(EXCHANGE_RATE_VND_TO_USD));

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if (fieldValue != null && fieldValue.length() > 0) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");

        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        for (String fieldName : fieldNames) {
            String fieldValue = fields.get(fieldName);
            if (fieldValue != null && fieldValue.length() > 0) {
                if (hashData.length() > 0) {
                    hashData.append('&');
                }
                hashData.append(fieldName).append('=').append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
            }
        }

        String signValue = VNPayConfig.hmacSHA512(VNPayConfig.secretKey, hashData.toString());
        boolean isPaymentSuccessful = false;
        String transactionStatus = "Failed";

        if (signValue.equals(vnp_SecureHash)) {
            if ("00".equals(request.getParameter("vnp_ResponseCode"))) {
                isPaymentSuccessful = true;
                transactionStatus = "Completed";
                BigDecimal totalAmountVND = new BigDecimal(request.getParameter("vnp_Amount")).divide(BigDecimal.valueOf(100)); // Convert to VND

                // Get booking information from session
                HttpSession session = request.getSession();
                User user = (User) session.getAttribute("user");
                int userId = user.getUserId();
                int hotelId = (int) session.getAttribute("hotelId");

                // Get selected rooms
                List<Room> selectedRoomsForCurrentHotel = (List<Room>) session.getAttribute("selectedRoomsForCurrentHotel");

                // Get check-in and check-out date from session
                String checkInDateStr = (String) session.getAttribute("checkInDate");
                String checkOutDateStr = (String) session.getAttribute("checkOutDate");

                SimpleDateFormat dateFormat = new SimpleDateFormat("EEE MMM dd HH:mm:ss z yyyy");
                Timestamp checkInTimestamp = null;
                Timestamp checkOutTimestamp = null;

                try {
                    Date checkInDate = dateFormat.parse(checkInDateStr);
                    Date checkOutDate = dateFormat.parse(checkOutDateStr);
                    checkInTimestamp = new Timestamp(checkInDate.getTime());
                    checkOutTimestamp = new Timestamp(checkOutDate.getTime());
                } catch (Exception e) {
                    logger.log(Level.SEVERE, "Error parsing date: ", e);
                    response.getWriter().write("{\"success\": false, \"message\": \"Invalid date format.\"}");
                    return;
                }

                int quantity = 1;
                double totalServiceAmount = totalAmountVND.doubleValue(); // Giả định toàn bộ amount là total

                try {
                    BookingDAO bookingDAO = new BookingDAO();
                    WalletDAO walletDAO = new WalletDAO();

                    // Lưu booking và lấy transactionId
                    int transactionId = -1;
                    for (Room room : selectedRoomsForCurrentHotel) {
                        int roomId = room.getRoomId();
                        boolean bookingResult = bookingDAO.bookRoom(userId, hotelId, roomId, checkInTimestamp, checkOutTimestamp, quantity, totalServiceAmount, "Completed", "Paid");
                        if (bookingResult) {
                            transactionId = bookingDAO.getLastBookingTransactionId(userId); // Giả định có phương thức này
                            System.out.println("Booking for room " + roomId + " successfully saved to database.");
                        } else {
                            System.out.println("Booking for room " + roomId + " failed during saving to database.");
                            isPaymentSuccessful = false;
                            transactionStatus = "Failed";
                            break;
                        }
                    }

                    if (isPaymentSuccessful) {
                        // Phân phối tiền
                        BigDecimal hotelAmountVND = totalAmountVND.subtract(ADMIN_BOOKING_FEE_VND); // Tiền cho Hotel Agent
                        int hotelAgentId = bookingDAO.getHotelAgentIdByHotelId(hotelId); // Giả định có phương thức này

                        // Cập nhật ví Admin
                        walletDAO.addToWallet(1, "Role", ADMIN_BOOKING_FEE_VND, "BookingFee", "Admin fee from booking", transactionId);
                        // Cập nhật ví Hotel Agent
                        walletDAO.addToWallet(hotelAgentId, "User", hotelAmountVND, "HotelPayment", "Payment from customer booking", transactionId);
                    }
                } catch (Exception e) {
                    logger.log(Level.SEVERE, "Error processing booking or wallet update: ", e);
                    isPaymentSuccessful = false;
                    transactionStatus = "Failed";
                }
            }
        }

        // Set response attributes
        request.setAttribute("isPaymentSuccessful", isPaymentSuccessful);
        request.setAttribute("transactionStatus", transactionStatus);
        request.setAttribute("vnp_TxnRef", request.getParameter("vnp_TxnRef"));
        request.setAttribute("vnp_Amount", request.getParameter("vnp_Amount"));
        request.setAttribute("vnp_ResponseCode", request.getParameter("vnp_ResponseCode"));
        request.setAttribute("vnp_TransactionNo", request.getParameter("vnp_TransactionNo"));
        request.setAttribute("vnp_BankCode", request.getParameter("vnp_BankCode"));
        request.setAttribute("vnp_PayDate", request.getParameter("vnp_PayDate"));

        request.getRequestDispatcher("/pages/payment/vnpay_return.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for processing payment results";
    }
}