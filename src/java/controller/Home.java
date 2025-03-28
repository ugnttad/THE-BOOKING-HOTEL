package controller;

import dao.HotelDAO;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Hotel;
import model.Role;
import model.User;

@WebServlet(name = "Home", urlPatterns = {"/home"})
public class Home extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = "/pages/home.jsp";

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        HotelDAO hotelDAO = new HotelDAO();
        List<Hotel> topHotels = null;
        try {
            int userId = (user != null) ? user.getUserId() : -1;
            topHotels = hotelDAO.getTopHotelsByBookings(userId, 8);
        } catch (Exception ex) {
            Logger.getLogger(Home.class.getName()).log(Level.SEVERE, "Error retrieving top hotels", ex);
        }
        request.setAttribute("topHotels", topHotels);

        if (user != null) {
            Role role = user.getRole();
            if (role.getRoleId() == 1) { // RoleId = 1 là Admin
                url = "/pages/adminHome.jsp";
            }
        }

        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}