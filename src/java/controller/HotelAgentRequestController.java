package controller;

import dao.HotelAgentRequestDAO;
import model.HotelAgentRequest;
import model.User;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/hotel-agent-requests/*")
public class HotelAgentRequestController extends HttpServlet {

    private HotelAgentRequestDAO requestDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        requestDAO = new HotelAgentRequestDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid request route");
            return;
        }

        try {
            if (pathInfo.startsWith("/view/")) {
                handleViewRequest(req, resp);
            } else if (pathInfo.equals("/request-status")) {
                handleRequestStatus(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Route not found");
            }
        } catch (Exception ex) {
            Logger.getLogger(HotelAgentRequestController.class.getName()).log(Level.SEVERE, null, ex);
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        resp.setContentType("application/json");

        try {
            if (pathInfo.equals("/approve")) {
                handleApproveRequest(req, resp);
            } else if (pathInfo.equals("/reject")) {
                handleRejectRequest(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Action not found");
            }
        } catch (Exception ex) {
            Logger.getLogger(HotelAgentRequestController.class.getName()).log(Level.SEVERE, null, ex);
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred");
        }
    }

    private void handleViewRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, Exception {
        String pathInfo = req.getPathInfo();
        try {
            int requestId = Integer.parseInt(pathInfo.substring(6)); // Lấy requestId từ URL: /view/{requestId}
            HotelAgentRequest request = requestDAO.getRequestById(requestId);
            if (request != null) {
                // Chuyển BusinessLicenseUrlsString thành List nếu cần
                if (request.getBusinessLicenseUrlsString() != null && !request.getBusinessLicenseUrlsString().isEmpty()) {
                    try {
                        List<String> urls = gson.fromJson(request.getBusinessLicenseUrlsString(), new TypeToken<List<String>>() {
                        }.getType());
                        request.setBusinessLicenseUrls(urls);
                    } catch (Exception e) {
                        // Nếu không phải JSON, giả định là chuỗi phân cách bằng dấu phẩy
                        request.setBusinessLicenseUrls(Arrays.asList(request.getBusinessLicenseUrlsString().split(",")));
                    }
                }
                req.setAttribute("request", request);
                req.getRequestDispatcher("/pages/admin/view-hotel-agent-request.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", "Request not found");
                req.getRequestDispatcher("/pages/admin/view-hotel-agent-request.jsp").forward(req, resp);
            }
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request ID");
        }
    }

    private void handleRequestStatus(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, Exception {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Lấy request mới nhất của user
        HotelAgentRequest request = requestDAO.getRequestByUserId(user.getUserId());
        if (request != null && request.getBusinessLicenseUrlsString() != null && !request.getBusinessLicenseUrlsString().isEmpty()) {
            try {
                List<String> urls = gson.fromJson(request.getBusinessLicenseUrlsString(), new TypeToken<List<String>>() {
                }.getType());
                request.setBusinessLicenseUrls(urls);
            } catch (Exception e) {
                // Nếu không phải JSON, giả định là chuỗi phân cách bằng dấu phẩy
                request.setBusinessLicenseUrls(Arrays.asList(request.getBusinessLicenseUrlsString().split(",")));
            }
        }

        req.setAttribute("request", request);
        req.getRequestDispatcher("/pages/request-status.jsp").forward(req, resp);
    }

    private void handleApproveRequest(HttpServletRequest req, HttpServletResponse resp) throws IOException, Exception {
        try {
            int requestId = Integer.parseInt(req.getParameter("requestId"));
            // Giả định admin ID được lấy từ session, tạm dùng ID 1
            int adminId = 1; // Thay bằng logic lấy admin hiện tại từ session nếu có
            boolean success = requestDAO.approveRequest(requestId, adminId);
            resp.getWriter().write(gson.toJson(new Response(success)));
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request ID");
        }
    }

    private void handleRejectRequest(HttpServletRequest req, HttpServletResponse resp) throws IOException, Exception {
        try {
            int requestId = Integer.parseInt(req.getParameter("requestId"));
            String rejectionReason = req.getParameter("rejectionReason");
            if (rejectionReason == null || rejectionReason.trim().isEmpty()) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Rejection reason is required");
                return;
            }
            // Giả định admin ID được lấy từ session, tạm dùng ID 1
            int adminId = 1; // Thay bằng logic lấy admin hiện tại từ session nếu có
            boolean success = requestDAO.rejectRequest(requestId, adminId, rejectionReason);
            resp.getWriter().write(gson.toJson(new Response(success)));
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request ID");
        }
    }

    // Response class for JSON serialization
    private static class Response {

        boolean success;

        Response(boolean success) {
            this.success = success;
        }
    }
}