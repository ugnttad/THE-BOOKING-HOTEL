package controller;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import config.CloudinaryConfig;
import dao.HotelDAO;
import dao.RoomDAO;
import dao.RoomFacilityDAO;
import dao.RoomTypeDAO;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Hotel;
import model.Room;
import model.RoomFacility;
import model.RoomType;
import model.User;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

@WebServlet(name = "HotelManagementController", urlPatterns = {"/add-room", "/edit-room"})
public class RoomManagementController extends HttpServlet {

    private Cloudinary cloudinary;

    @Override
    public void init() {
        this.cloudinary = CloudinaryConfig.getCloudinary();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        if ("/add-room".equals(action)) {
            try {
                handleAddRoomPage(request, response);
            } catch (Exception ex) {
                Logger.getLogger(HotelManagementController.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else if ("/edit-room".equals(action)) {
            handleEditRoomPage(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("/add-room".equals(request.getServletPath())) {
            handleAddRoomSubmit(request, response);
        } else if ("/edit-room".equals(request.getServletPath())) {
            handleEditRoomSubmit(request, response);
        }
    }

    private void handleEditRoomPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRole().getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            RoomDAO roomDAO = new RoomDAO();
            HotelDAO hotelDAO = new HotelDAO();
            RoomTypeDAO roomTypeDAO = new RoomTypeDAO();

            Room room = roomDAO.getRoomById(roomId); // Giả định có hàm này
            if (room == null) {
                request.setAttribute("error", "Room not found.");
                request.getRequestDispatcher("/pages/hotel-management/error.jsp").forward(request, response);
                return;
            }

            Hotel hotel = hotelDAO.getHotelById(room.getHotelId());
            if (hotel == null || hotel.getHotelAgentId() != user.getUserId()) {
                request.setAttribute("error", "You don't have permission to edit this room.");
                request.getRequestDispatcher("/pages/hotel-management/error.jsp").forward(request, response);
                return;
            }

            request.setAttribute("room", room);
            request.setAttribute("hotel", hotel);
            request.setAttribute("roomTypes", roomTypeDAO.getAllRoomTypes());
            request.setAttribute("roomFacilities", roomDAO.getAllRoomFacilities()); // Giả định có hàm này
            request.setAttribute("roomFacilityIds", roomDAO.getRoomFacilityIds(roomId)); // Giả định có hàm này

            request.getRequestDispatcher("/pages/hotel-management/edit-room.jsp").forward(request, response);
        } catch (Exception e) {
            Logger.getLogger(HotelManagementController.class.getName()).log(Level.SEVERE, "Error loading edit room page", e);
            request.setAttribute("error", "Error loading page: " + e.getMessage());
            request.getRequestDispatcher("/pages/hotel-management/error.jsp").forward(request, response);
        }
    }

    private void handleEditRoomSubmit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRole().getRoleId() != 3) {
            request.setAttribute("error", "You must be logged in as a Hotel Agent to edit a room.");
            request.getRequestDispatcher("/pages/hotel-management/edit-room.jsp").forward(request, response);
            return;
        }

        int roomId = 0;
        String roomNumber = null;
        String roomDescription = null;
        int hotelId = 0;
        int roomTypeId = 0;
        int capacity = 0;
        double price = 0;
        List<String> facilityIds = new ArrayList<>();
        List<String> imageUrls = new ArrayList<>();

        try {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);

            List<FileItem> items = upload.parseRequest(request);
            for (FileItem item : items) {
                if (item.isFormField()) {
                    String fieldName = item.getFieldName();
                    String value = item.getString("UTF-8");
                    switch (fieldName) {
                        case "roomId" ->
                            roomId = Integer.parseInt(value);
                        case "roomNumber" ->
                            roomNumber = value;
                        case "roomDescription" ->
                            roomDescription = value;
                        case "hotelId" ->
                            hotelId = Integer.parseInt(value);
                        case "type" ->
                            roomTypeId = Integer.parseInt(value);
                        case "capacity" ->
                            capacity = Integer.parseInt(value);
                        case "price" ->
                            price = Double.parseDouble(value);
                        case "facilityIds" ->
                            facilityIds.add(value);
                    }
                } else if (item.getFieldName().equals("galleryImages") && item.getSize() > 0) {
                    File tempFile = File.createTempFile("room_img_", ".jpg");
                    item.write(tempFile);
                    Map<String, Object> uploadResult = cloudinary.uploader().upload(tempFile, ObjectUtils.emptyMap());
                    String imageUrl = (String) uploadResult.get("secure_url");
                    imageUrls.add(imageUrl);
                    Files.deleteIfExists(tempFile.toPath());
                }
            }

            // Kiểm tra dữ liệu
            if (roomId <= 0 || hotelId <= 0) {
                request.setAttribute("error", "Invalid room or hotel ID.");
                request.getRequestDispatcher("/pages/hotel-management/edit-room.jsp").forward(request, response);
                return;
            }
            if (roomNumber == null || roomNumber.trim().isEmpty()) {
                request.setAttribute("error", "Room number is required.");
                request.getRequestDispatcher("/pages/hotel-management/edit-room.jsp").forward(request, response);
                return;
            }
            if (roomTypeId <= 0) {
                request.setAttribute("error", "Room type is required.");
                request.getRequestDispatcher("/pages/hotel-management/edit-room.jsp").forward(request, response);
                return;
            }
            if (capacity <= 0) {
                request.setAttribute("error", "Capacity must be greater than 0.");
                request.getRequestDispatcher("/pages/hotel-management/edit-room.jsp").forward(request, response);
                return;
            }
            if (price < 0) {
                request.setAttribute("error", "Price cannot be negative.");
                request.getRequestDispatcher("/pages/hotel-management/edit-room.jsp").forward(request, response);
                return;
            }

            // Cập nhật database
            RoomDAO roomDAO = new RoomDAO();
            Room existingRoom = roomDAO.getRoomById(roomId);
            HotelDAO hotelDAO = new HotelDAO();
            if (existingRoom == null || hotelDAO.getHotelById(hotelId).getHotelAgentId() != user.getUserId()) {
                request.setAttribute("error", "Room not found or you don't have permission to edit.");
                request.getRequestDispatcher("/pages/hotel-management/edit-room.jsp").forward(request, response);
                return;
            }

            // Nếu không upload ảnh mới, giữ nguyên ảnh cũ
            List<String> updatedImageUrls = imageUrls.isEmpty()
                    ? new org.json.JSONArray(existingRoom.getRoomImageURLs()).toList().stream().map(Object::toString).collect(Collectors.toList())
                    : imageUrls;

            boolean success = roomDAO.updateRoom(roomId, hotelId, roomNumber, roomDescription, roomTypeId, price, capacity, facilityIds, updatedImageUrls);
            if (!success) {
                request.setAttribute("error", "Failed to update room. Please try again.");
                request.getRequestDispatcher("/pages/hotel-management/edit-room.jsp").forward(request, response);
                return;
            }

            response.sendRedirect(request.getContextPath() + "/room-list?success=Room updated successfully");
        } catch (Exception e) {
            Logger.getLogger(HotelManagementController.class.getName()).log(Level.SEVERE, "Error editing room", e);
            request.setAttribute("error", "Error editing room: " + e.getMessage());
            request.getRequestDispatcher("/pages/hotel-management/edit-room.jsp").forward(request, response);
        }
    }

    private void handleAddRoomSubmit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRole().getRoleId() != 3) { // RoleId 3 là Hotel Agent
            request.setAttribute("error", "You must be logged in as a Hotel Agent to add a room.");
            request.getRequestDispatcher("/pages/hotel-management/add-room.jsp").forward(request, response);
            return;
        }

        String roomNumber = null;
        String roomDescription = null;
        int hotelId = 0;
        int roomTypeId = 0;
        int capacity = 0;
        double price = 0;
        List<String> facilityIds = new ArrayList<>();
        List<String> imageUrls = new ArrayList<>();

        try {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);

            List<FileItem> items = upload.parseRequest(request);
            for (FileItem item : items) {
                if (item.isFormField()) {
                    String fieldName = item.getFieldName();
                    String value = item.getString("UTF-8");
                    switch (fieldName) {
                        case "roomNumber" ->
                            roomNumber = value;
                        case "roomDescription" ->
                            roomDescription = value;
                        case "hotelId" ->
                            hotelId = Integer.parseInt(value);
                        case "type" ->
                            roomTypeId = Integer.parseInt(value);
                        case "price" ->
                            price = Double.parseDouble(value);
                        case "capacity" ->
                            capacity = Integer.parseInt(value);
                        case "facilityIds" ->
                            facilityIds.add(value);
                    }
                } else if (item.getFieldName().equals("galleryImages") && item.getSize() > 0) {
                    File tempFile = File.createTempFile("room_img_", ".jpg");
                    item.write(tempFile);
                    Map<String, Object> uploadResult = cloudinary.uploader().upload(tempFile, ObjectUtils.emptyMap());
                    String imageUrl = (String) uploadResult.get("secure_url");
                    imageUrls.add(imageUrl);
                    Files.deleteIfExists(tempFile.toPath());
                }
            }

            // Kiểm tra dữ liệu đầu vào
            if (roomNumber == null || roomNumber.trim().isEmpty()) {
                request.setAttribute("error", "Room number is required.");
                request.getRequestDispatcher("/pages/hotel-management/add-room.jsp").forward(request, response);
                return;
            }
            if (hotelId <= 0) {
                request.setAttribute("error", "Invalid hotel selection.");
                request.getRequestDispatcher("/pages/hotel-management/add-room.jsp").forward(request, response);
                return;
            }
            if (roomTypeId <= 0) {
                request.setAttribute("error", "Invalid room type selection.");
                request.getRequestDispatcher("/pages/hotel-management/add-room.jsp").forward(request, response);
                return;
            }
            if (price < 0) {
                request.setAttribute("error", "Price cannot be negative.");
                request.getRequestDispatcher("/pages/hotel-management/add-room.jsp").forward(request, response);
                return;
            }
            if (capacity <= 0) {
                request.setAttribute("error", "Capacity must be greater than 0.");
                request.getRequestDispatcher("/pages/hotel-management/add-room.jsp").forward(request, response);
                return;
            }

            // Lưu vào database
            RoomDAO roomDAO = new RoomDAO();
            int roomId = roomDAO.addRoom(hotelId, roomNumber, roomDescription, roomTypeId, price, capacity, facilityIds, imageUrls);
            if (roomId == -1) {
                request.setAttribute("error", "Failed to add room to database. Please try again.");
                request.getRequestDispatcher("/pages/hotel-management/add-room.jsp").forward(request, response);
                return;
            }

            // Thành công: redirect
            response.sendRedirect(request.getContextPath() + "/room-list?success=Room added successfully");

        } catch (Exception e) {
            Logger.getLogger(HotelManagementController.class.getName()).log(Level.SEVERE, "Error adding room", e);
            request.setAttribute("error", "Error adding room: " + e.getMessage());
            request.getRequestDispatcher("/pages/hotel-management/add-room.jsp").forward(request, response);
        }
    }

    private void handleAddRoomPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        int hotelId = Integer.parseInt(request.getParameter("hotelId"));
        HotelDAO hotelDAO = new HotelDAO();

        RoomTypeDAO roomTypeDAO = new RoomTypeDAO();
        List<RoomType> roomTypes = roomTypeDAO.getAllRoomTypes();

        RoomFacilityDAO roomFacilityDAO = new RoomFacilityDAO();
        List<RoomFacility> roomFacilities = roomFacilityDAO.getAllRoomFacilities();

        request.setAttribute("hotel", hotelDAO.getHotelById(hotelId));
        request.setAttribute("roomTypes", roomTypes);
        request.setAttribute("roomFacilities", roomFacilities);
        request.getRequestDispatcher("/pages/hotel-management/add-room.jsp").forward(request, response);
    }
}
