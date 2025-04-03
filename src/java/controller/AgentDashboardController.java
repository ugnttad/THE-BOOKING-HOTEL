package controller;

import dao.BookingDAO;
import dao.FeedbackDAO;
import dao.HotelDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.Year;
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
import model.Booking;
import model.Hotel;
import model.User;

@WebServlet(name = "AgentDashboardController", urlPatterns = {"/agent-dashboard"})
public class AgentDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        if ("/agent-dashboard".equals(action)) {
            try {
                handleAgentDashboardPage(request, response);
            } catch (Exception ex) {
                Logger.getLogger(AgentDashboardController.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else {

        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("/add-hotel".equals(request.getServletPath())) {
        } else {
        }
    }

    private void handleAgentDashboardPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRole().getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        int totalBooking = bookingDAO.getBookingCountByHotelAgentId(user.getUserId());

        double totalEarnings = bookingDAO.getTotalRevenueByHotelAgentId(user.getUserId());

        Map<Integer, Double> earningsByYear = bookingDAO.getEarningsByHotelAgentId(user.getUserId());

        int currentYear = Year.now().getValue();
        int yearMinus1 = currentYear - 1;
        int yearMinus2 = currentYear - 2;
        
        HotelDAO hotelDAO = new HotelDAO();
        List<Hotel> recentlyBookedHotels = hotelDAO.getRecentlyBookedHotelsByAgentId(user.getUserId());

        request.setAttribute("earningsByYear", earningsByYear);
        request.setAttribute("currentYear", currentYear);
        request.setAttribute("yearMinus1", yearMinus1);
        request.setAttribute("yearMinus2", yearMinus2);

        int totalHotel = hotelDAO.getHotelCountByAgentId(user.getUserId());

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        int totalFeedback = feedbackDAO.getFeedbackCountByAgentId(user.getUserId());

        List<Booking> latestTransactions = bookingDAO.getLatestTransactionsByAgentId(user.getUserId());
        
        request.setAttribute("recentlyBookedHotels", recentlyBookedHotels);
        request.setAttribute("totalBooking", totalBooking);
        request.setAttribute("totalHotel", totalHotel);
        request.setAttribute("totalEarnings", totalEarnings);
        request.setAttribute("totalFeedback", totalFeedback);
        request.setAttribute("latestTransactions", latestTransactions);
        request.getRequestDispatcher("/pages/hotel-management/agent-dashboard.jsp").forward(request, response);
    }
}
