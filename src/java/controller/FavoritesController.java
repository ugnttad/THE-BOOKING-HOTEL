package controller;

import dao.FavoritesDAO;
import model.Hotel;
import model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/favorites")
public class FavoritesController extends HttpServlet {

    private FavoritesDAO favoritesDAO;

    @Override
    public void init() throws ServletException {
        favoritesDAO = new FavoritesDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("/login");
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("list".equals(action)) {
                // Lấy danh sách khách sạn yêu thích
                List<Hotel> favoriteHotels = favoritesDAO.getFavoriteHotels(user.getUserId());
                request.setAttribute("favoriteHotels", favoriteHotels);
                request.getRequestDispatcher("/pages/wishlist.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request");
        } catch (Exception ex) {
            Logger.getLogger(FavoritesController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("/login");
            return;
        }

        response.setContentType("application/json");
        String action = request.getParameter("action");
        int hotelId = Integer.parseInt(request.getParameter("hotelId"));

        try {
            if ("add".equals(action)) {
                boolean success = favoritesDAO.addFavorite(user.getUserId(), hotelId);
                if (success) {
                    response.getWriter().write("{\"status\": \"success\", \"message\": \"Added to favorites\"}");
                } else {
                    response.setStatus(HttpServletResponse.SC_CONFLICT);
                    response.getWriter().write("{\"status\": \"conflict\", \"message\": \"Hotel already in favorites\"}");
                }
            } else if ("remove".equals(action)) {
                favoritesDAO.removeFavorite(user.getUserId(), hotelId); // Xóa mà không cần kiểm tra success
                response.getWriter().write("{\"status\": \"success\", \"message\": \"Removed from favorites\"}");
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request");
        } catch (Exception ex) {
            Logger.getLogger(FavoritesController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
