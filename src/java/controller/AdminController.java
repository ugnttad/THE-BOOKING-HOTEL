package controller;

import dao.UserDAO;
import dao.BookingDAO; // Assumed DAO for bookings
import model.User;
import model.Booking; // Assumed model for bookings
import com.google.gson.Gson;
import dao.HotelAgentRequestDAO;
import dao.HotelDAO;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Hotel;
import model.HotelAgentRequest;

@WebServlet("/admin/*")
public class AdminController extends HttpServlet {

    private UserDAO userDAO;
    private BookingDAO bookingDAO; // Add this if you have a BookingDAO
    private Gson gson;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        bookingDAO = new BookingDAO(); // Initialize your BookingDAO
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo(); // e.g., "/users", "/dashboard", "/dashboard/data"

        if (pathInfo == null || pathInfo.equals("/")) {
            // Redirect base /admin/ to /admin/dashboard (default landing page)
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        try {
            if (pathInfo.startsWith("/users")) {
                String subPath = pathInfo.substring(6); // Remove "/users" prefix
                if (subPath.equals("") || subPath.equals("/")) {
                    // Render the user management JSP
                    req.getRequestDispatcher("/pages/admin/user-management.jsp").forward(req, resp);
                } else {
                    // Handle AJAX requests for user management
                    handleUserManagement(req, resp, subPath);
                }
            } else if (pathInfo.startsWith("/dashboard")) {
                String subPath = pathInfo.substring(10); // Remove "/dashboard" prefix
                if (subPath.equals("") || subPath.equals("/")) {
                    // Render the dashboard JSP
                    req.getRequestDispatcher("/pages/admin/dashboard.jsp").forward(req, resp);
                } else {
                    // Handle AJAX requests for dashboard data
                    handleDashboard(req, resp, subPath);
                }
            } else if (pathInfo.startsWith("/hotels")) { // New route
                String subPath = pathInfo.substring(7);
                if (subPath.equals("") || subPath.equals("/")) {
                    req.getRequestDispatcher("/pages/admin/hotel-management.jsp").forward(req, resp);
                } else {
                    handleHotels(req, resp, subPath);
                }
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Admin route not found");
            }
        } catch (Exception ex) {
            Logger.getLogger(AdminController.class.getName()).log(Level.SEVERE, null, ex);
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred");
        }
    }

    private void handleHotels(HttpServletRequest req, HttpServletResponse resp, String subPath)
            throws IOException, Exception {
        resp.setContentType("application/json");

        HotelDAO hotelDAO = new HotelDAO();

        if (subPath.equals("/data")) {
            List<Hotel> hotels = hotelDAO.getAllHotelsWithRevenue();
            gson.toJson(hotels, resp.getWriter());
        } else if (subPath.startsWith("/agent/")) {
            try {
                int agentId = Integer.parseInt(subPath.substring(7));
                User agent = hotelDAO.getAgentDetailsById(agentId);
                if (agent != null) {
                    gson.toJson(agent, resp.getWriter());
                } else {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Agent not found");
                }
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid agent ID");
            }
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid hotels route");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();

        try {
            if (pathInfo != null && pathInfo.startsWith("/users")) {
                handleUserManagementPost(req, resp, pathInfo.substring(6));
            } else if (pathInfo.startsWith("/hotels")) {
                handleHotelManagementPost(req, resp, pathInfo.substring(7));
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Admin route not found");
            }
        } catch (Exception ex) {
            Logger.getLogger(AdminController.class.getName()).log(Level.SEVERE, null, ex);
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred");
        }
    }

    private void handleHotelManagementPost(HttpServletRequest req, HttpServletResponse resp, String subPath)
            throws IOException, Exception {
        resp.setContentType("application/json");

        HotelDAO hotelDAO = new HotelDAO();
        String hotelIdParam = req.getParameter("hotelId");

        if (hotelIdParam == null || hotelIdParam.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hotel ID is required");
            return;
        }

        try {
            int hotelId = Integer.parseInt(hotelIdParam);
            System.out.println(hotelId);

            if (subPath.equals("/ban")) {
                boolean success = hotelDAO.banHotel(hotelId);
                gson.toJson(new Response(success), resp.getWriter());
            } else if (subPath.equals("/unban")) {
                boolean success = hotelDAO.unbanHotel(hotelId);
                gson.toJson(new Response(success), resp.getWriter());
            } else if (subPath.equals("/accept")) {
                boolean success = hotelDAO.acceptHotel(hotelId);
                gson.toJson(new Response(success), resp.getWriter());
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid hotel management action");
            }
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid hotel ID");
        }
    }

    private void handleUserManagement(HttpServletRequest req, HttpServletResponse resp, String subPath)
            throws ServletException, IOException, Exception {
        resp.setContentType("application/json");

        if (subPath.equals("/data")) {
            // Return all users for DataTables
            List<User> users = userDAO.getAllUsers();
            gson.toJson(users, resp.getWriter());
        } else if (subPath.startsWith("/view/")) {
            // Return specific user details as JSON with HotelAgentRequest
            try {
                int userId = Integer.parseInt(subPath.substring(6));
                User user = userDAO.getUserById(userId);
                if (user != null) {
                    HotelAgentRequestDAO hotelAgentRequestDAO = new HotelAgentRequestDAO();
                    // Lấy thông tin HotelAgentRequest nếu có
                    HotelAgentRequest agentRequest = hotelAgentRequestDAO.getPendingRequestByUserId(userId);
                    Map<String, Object> responseMap = new HashMap<>();
                    responseMap.put("userId", user.getUserId());
                    responseMap.put("username", user.getUsername());
                    responseMap.put("firstName", user.getFirstName());
                    responseMap.put("lastName", user.getLastName());
                    responseMap.put("email", user.getEmail());
                    responseMap.put("phoneNumber", user.getPhoneNumber());
                    responseMap.put("createdAt", user.getCreatedAt() != null ? user.getCreatedAt().toString() : null);
                    responseMap.put("googleId", user.getGoogleId());
                    responseMap.put("avatarUrl", user.getAvatarUrl());
                    responseMap.put("isActive", user.isActive());
                    responseMap.put("isBanned", user.isBanned());
                    Map<String, String> role = new HashMap<>();
                    role.put("roleName", user.getRole().getRoleName());
                    responseMap.put("role", role);

                    if (agentRequest != null) {
                        Map<String, Object> requestMap = new HashMap<>();
                        requestMap.put("requestId", agentRequest.getRequestId());
                        requestMap.put("requestStatus", agentRequest.getRequestStatus());
                        requestMap.put("hotelName", agentRequest.getHotelName());
                        requestMap.put("businessLicense", agentRequest.getBusinessLicenseUrls());
                        requestMap.put("address", agentRequest.getAddress());
                        requestMap.put("description", agentRequest.getDescription());
                        requestMap.put("requestType", agentRequest.getRequestType());
                        requestMap.put("submittedAt", agentRequest.getSubmittedAt() != null ? agentRequest.getSubmittedAt().toString() : null);
                        responseMap.put("hotelAgentRequest", requestMap);
                    }

                    gson.toJson(responseMap, resp.getWriter());
                } else {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
                }
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID");
            }
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid user management route");
        }
    }

    private void handleUserManagementPost(HttpServletRequest req, HttpServletResponse resp, String subPath)
            throws IOException, Exception {
        resp.setContentType("application/json");

        if (subPath.equals("/ban")) {
            try {
                int userId = Integer.parseInt(req.getParameter("userId"));
                boolean success = userDAO.banUser(userId);
                gson.toJson(new Response(success), resp.getWriter());
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID");
            }
        } else if (subPath.equals("/unban")) {
            try {
                int userId = Integer.parseInt(req.getParameter("userId"));
                boolean success = userDAO.unbanUser(userId);
                gson.toJson(new Response(success), resp.getWriter());
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID");
            }
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid user management action");
        }
    }

    private void handleDashboard(HttpServletRequest req, HttpServletResponse resp, String subPath)
            throws IOException, Exception {
        resp.setContentType("application/json");

        if (subPath.equals("/data")) {
            // Fetch dashboard statistics
            List<User> users = userDAO.getAllUsers();
            int totalUsers = users.size();
            int activeUsers = (int) users.stream().filter(User::isActive).count();

            // Simulated booking data (replace with actual BookingDAO calls)
            List<Booking> bookings = bookingDAO != null ? bookingDAO.getAllBookings() : new ArrayList<>(); // Placeholder
            int totalBookings = bookings.size();
            int completedBookings = (int) bookings.stream().filter(b -> b.getBookingStatus().equals("Completed")).count();
            int pendingBookings = (int) bookings.stream().filter(b -> b.getBookingStatus().equals("Pending")).count();
            int cancelledBookings = (int) bookings.stream().filter(b -> b.getBookingStatus().equals("Cancelled")).count();
            double totalRevenue = bookings.stream().mapToDouble(Booking::getTotalAmount).sum(); // Assuming Booking has getAmount()

            Map<String, Double> revenueGrowthMap = new HashMap<>();
            SimpleDateFormat monthFormat = new SimpleDateFormat("MMM");
            for (Booking booking : bookings) {
                if ("Completed".equals(booking.getBookingStatus())) {
                    String month = monthFormat.format(booking.getCreatedAt());
                    double amount = booking.getTotalAmount(); // Already in USD
                    revenueGrowthMap.put(month, revenueGrowthMap.getOrDefault(month, 0.0) + amount);
                }
            }
            String[] months = revenueGrowthMap.keySet().toArray(new String[0]);
            double[] revenueGrowthData = revenueGrowthMap.values().stream().mapToDouble(Double::doubleValue).toArray();

            // Build JSON response
            DashboardData data = new DashboardData();
            data.totalUsers = totalUsers;
            data.activeUsers = activeUsers;
            data.totalBookings = totalBookings;
            data.totalRevenue = totalRevenue;
            data.revenueGrowth = new RevenueGrowth(months, revenueGrowthData);
            data.bookingStatus = new BookingStatus(completedBookings, pendingBookings, cancelledBookings);

            gson.toJson(data, resp.getWriter());
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid dashboard route");
        }
    }

    // Response classes for JSON serialization
    private static class Response {

        boolean success;

        Response(boolean success) {
            this.success = success;
        }
    }

    private static class DashboardData {

        int totalUsers;
        int activeUsers;
        int totalBookings;
        double totalRevenue;
        RevenueGrowth revenueGrowth; // Changed from UserGrowth
        BookingStatus bookingStatus;
    }

    private static class RevenueGrowth { // Changed from UserGrowth

        String[] labels;
        double[] data; // Changed to double[] for revenue

        RevenueGrowth(String[] labels, double[] data) {
            this.labels = labels;
            this.data = data;
        }
    }

    private static class BookingStatus {

        int completed;
        int pending;
        int cancelled;

        BookingStatus(int completed, int pending, int cancelled) {
            this.completed = completed;
            this.pending = pending;
            this.cancelled = cancelled;
        }
    }
}
