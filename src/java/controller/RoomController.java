package controller;

import dao.RoomDAO;
import java.io.IOException;
import java.util.ArrayList;
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

@WebServlet(name = "RoomController", urlPatterns = {"/updateSelectedRoom"})
public class RoomController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private RoomDAO roomDAO;

    @Override
    public void init() throws ServletException {
        roomDAO = new RoomDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get session and parameters
        HttpSession session = request.getSession();
        Map<Integer, List<Room>> selectedRooms = (Map<Integer, List<Room>>) session.getAttribute("selectedRooms");
        if (selectedRooms == null) {
            selectedRooms = new HashMap<>();
        }

        int roomId = Integer.parseInt(request.getParameter("roomId"));
        boolean isSelected = Boolean.parseBoolean(request.getParameter("selected"));
        int hotelId = Integer.parseInt(request.getParameter("hotelId")); // ID của khách sạn

        // Get the room object
        Room room = null;
        try {
            room = roomDAO.getRoomById(roomId);
        } catch (Exception ex) {
            Logger.getLogger(RoomController.class.getName()).log(Level.SEVERE, null, ex);
        }

        // Retrieve or initialize the list of selected rooms for the current hotel
        List<Room> hotelRooms = selectedRooms.getOrDefault(hotelId, new ArrayList<>());

        System.out.println("isSelected: " + isSelected);

        if (isSelected) {
            // Add room to the selectedRooms list for the specific hotel if not already selected
            if (!hotelRooms.contains(room)) {
                hotelRooms.add(room);
            }
        } else {
            // Remove room from the selectedRooms list for the specific hotel
            hotelRooms.remove(room);
        }

        // Update the map with the selected rooms for this hotel
        selectedRooms.put(hotelId, hotelRooms);

        // Set the updated map back to session
        session.setAttribute("selectedRooms", selectedRooms);

        // Respond to the client
        response.getWriter().write("Selected rooms updated.");
    }
}