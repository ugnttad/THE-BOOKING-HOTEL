package controller;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import config.CloudinaryConfig;
import dao.UserDAO;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import model.User;

@WebServlet(name = "UserProfile", urlPatterns = {"/user-profile", "/user-profile/edit", "/upload-avatar"})
@MultipartConfig
public class UserProfile extends HttpServlet {

    private Cloudinary cloudinary;

    @Override
    public void init() {
        this.cloudinary = CloudinaryConfig.getCloudinary();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        switch (action) {
            case "/user-profile" -> {
                viewProfile(request, response);
            }
            case "/user-profile/edit" -> {
                viewEditProfile(request, response);
            }
            default ->
                response.sendRedirect("/user-profile");
        }
    }

    private void viewProfile(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("/HotelBooking");
            return;
        }

        request.getRequestDispatcher("/pages/user-profile.jsp").forward(request, response);
    }

    private void viewEditProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("/HotelBooking");
        }

        request.getRequestDispatcher("/pages/profile-settings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        switch (action) {
            case "/user-profile/edit" -> {
                try {
                    editProfile(request, response);
                } catch (Exception ex) {
                    Logger.getLogger(UserProfile.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            case "/upload-avatar" -> {
                try {
                    handleUploadAvatar(request, response);
                } catch (Exception ex) {
                    Logger.getLogger(UserProfile.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            default ->
                response.sendRedirect("/user-profile");
        }
    }

    private void handleUploadAvatar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"User not logged in.\"}");
            return;
        }

        Part filePart = request.getPart("avatar");
        if (filePart == null || filePart.getSize() == 0) {
            response.getWriter().write("{\"success\": false, \"message\": \"No file uploaded.\"}");
            return;
        }

        // Lưu file tạm thời
        File tempFile = File.createTempFile("upload_", ".jpg");
        filePart.write(tempFile.getAbsolutePath());

        try {
            Map<String, Object> uploadResult = cloudinary.uploader().upload(
                    tempFile, ObjectUtils.emptyMap());

            // Lấy đường dẫn ảnh sau khi upload
            String avatarUrl = (String) uploadResult.get("secure_url");

            // Cập nhật vào database
            UserDAO userDAO = new UserDAO();
            boolean updateSuccess = userDAO.updateUserAvatar(avatarUrl, user.getUserId());

            if (updateSuccess) {
                user.setAvatarUrl(avatarUrl);
                session.setAttribute("user", user);
                response.getWriter().write("{\"success\": true, \"avatarUrl\": \"" + avatarUrl + "\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Database update failed.\"}");
            }
        } catch (Exception ex) {
            Logger.getLogger(UserProfile.class.getName()).log(Level.SEVERE, null, ex);
            response.getWriter().write("{\"success\": false, \"message\": \"File upload failed.\"}");
        } finally {
            Files.deleteIfExists(tempFile.toPath()); // Xóa file sau khi upload
        }
    }

    private void editProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("/HotelBooking");
            return;
        }

        // Lấy dữ liệu từ request
        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // Cập nhật thông tin người dùng
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setPhoneNumber(phone);

        // Lưu vào database
        UserDAO userDAO = new UserDAO();
        boolean updated = userDAO.updateUser(user);

        if (updated) {
            session.setAttribute("user", user); // Cập nhật session
            response.sendRedirect("/HotelBooking/user-profile?success=true");
        } else {
            response.sendRedirect("/HotelBooking/user-profile/edit?error=true");
        }
    }
}
