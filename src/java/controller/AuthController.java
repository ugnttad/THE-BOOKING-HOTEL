package controller;

import constant.Paths;
import dao.UserDAO;
import jakarta.mail.MessagingException;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Role;
import model.Room;
import model.User;
import utils.EmailUtils;
//import utils.GoogleUtils;
import utils.PasswordUtils;

@WebServlet(name = "AuthController", urlPatterns = {"/register", "/login", "/logout", "/google-login", "/verify-email", "/forgot-password", "/verify-forgot-password", "/reset-password", "change-password"})
public class AuthController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/google-login" -> {
                handleGoogleLogin(request, response);
            }

            case "/reset-password" -> {
                viewResetPassword(request, response);
            }

            case "/change-password" -> {
                viewChangePassword(request, response);
            }

            case "/logout" -> {
                handleLogout(request, response);
            }

            default ->
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/register" -> {
                try {
                    handleRegister(request, response);
                } catch (NoSuchAlgorithmException | MessagingException ex) {
                    Logger.getLogger(AuthController.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            case "/login" -> {
                try {
                    handleLogin(request, response);
                } catch (Exception ex) {
                    Logger.getLogger(AuthController.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            case "/forgot-password" -> {
                try {
                    handleForgotPassword(request, response);
                } catch (Exception ex) {
                    Logger.getLogger(AuthController.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            case "/verify-forgot-password" -> {
                try {
                    handleVerifyForgotPassword(request, response);
                } catch (IOException | ServletException ex) {
                    Logger.getLogger(AuthController.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            case "/reset-password" -> {
                try {
                    handleResetPassword(request, response);
                } catch (Exception ex) {
                    Logger.getLogger(AuthController.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            case "/change-password" -> {
                try {
                    handleChangePassword(request, response);
                } catch (Exception ex) {
                    Logger.getLogger(AuthController.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            case "/verify-email" ->
                handleVerifyEmail(request, response);
            default ->
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request.");
        }
    }

    private void viewResetPassword(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.getRequestDispatcher("/pages/reset-password.jsp").forward(request, response);
    }

    private void viewChangePassword(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.getRequestDispatcher("/pages/change-password.jsp").forward(request, response);
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, NoSuchAlgorithmException, MessagingException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String username = request.getParameter("username");
        String lastname = request.getParameter("lastname");
        String firstname = request.getParameter("firstname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!password.equals(confirmPassword)) {
            out.write("{\"success\": false, \"message\": \"Passwords do not match.\"}");
            out.flush();
            return;
        }

        if (userDAO.isUsernameTaken(username)) {
            out.write("{\"success\": false, \"message\": \"Username is already taken.\"}");
            out.flush();
            return;
        }

        if (userDAO.isEmailTaken(email)) {
            out.write("{\"success\": false, \"message\": \"Email is already registered.\"}");
            out.flush();
            return;
        }

        byte[] salt = PasswordUtils.generateSalt();
        String hashedPassword = PasswordUtils.hashPassword(password, salt);

        String otp = String.format("%06d", new Random().nextInt(999999));
        HttpSession session = request.getSession();
        session.setAttribute("firstname", firstname);
        session.setAttribute("lastname", lastname);
        session.setAttribute("email", email);
        session.setAttribute("username", username);
        session.setAttribute("hashedPassword", hashedPassword);
        session.setAttribute("salt", salt);
        session.setAttribute("otp", otp);

        EmailUtils.sendEmail(email, "Email Verification", "Your OTP is: " + otp);

        out.write("{\"success\": true}");
        out.flush();
    }

    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String email = request.getParameter("email");
        User user = userDAO.getUserByEmail(email);

        if (user == null) {
            out.write("{\"success\": false, \"message\": \"Email is not registered.\"}");
            out.flush();
            return;
        }

        String otp = String.format("%06d", new Random().nextInt(999999));
        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("resetEmail", email);

        try {
            EmailUtils.sendEmail(email, "Password Reset OTP", "Your OTP is: " + otp);
            out.write("{\"success\": true, \"message\": \"OTP sent to your email.\"}");
        } catch (MessagingException e) {
            Logger.getLogger(AuthController.class.getName()).log(Level.SEVERE, null, e);
            out.write("{\"success\": false, \"message\": \"Failed to send OTP.\"}");
        }
        out.flush();
    }

    private void handleVerifyForgotPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        String enteredOtp = request.getParameter("otp");
        String sessionOtp = (String) session.getAttribute("otp");

        if (enteredOtp != null && enteredOtp.equals(sessionOtp)) {
            session.setAttribute("otpVerified", true);
            out.write("{\"success\": true, \"message\": \"OTP verified. You can reset your password now.\"}");
        } else {
            out.write("{\"success\": false, \"message\": \"Invalid OTP.\"}");
        }
        out.flush();
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, NoSuchAlgorithmException, Exception {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
        String email = (String) session.getAttribute("resetEmail");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            out.write("{\"success\": false, \"message\": \"Passwords do not match.\"}");
            out.flush();
            return;
        }

        if (otpVerified == null || !otpVerified || email == null) {
            out.write("{\"success\": false, \"message\": \"Unauthorized request.\"}");
            out.flush();
            return;
        }

        byte[] salt = PasswordUtils.generateSalt();
        String hashedPassword = PasswordUtils.hashPassword(newPassword, salt);
        userDAO.updatePasswordByEmail(email, hashedPassword, salt);

        session.removeAttribute("otp");
        session.removeAttribute("otpVerified");
        session.removeAttribute("resetEmail");

        out.write("{\"success\": true, \"message\": \"Password reset successfully.\"}");
        out.flush();
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, NoSuchAlgorithmException, Exception {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("user");

        if (loggedUser == null) {
            out.write("{\"success\": false, \"message\": \"User not logged in.\"}");
            out.flush();
            return;
        }

        String currentPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!PasswordUtils.verifyPassword(currentPassword, loggedUser.getStoredSalt(), loggedUser.getPasswordHash())) {
            out.write("{\"success\": false, \"message\": \"Incorrect current password.\"}");
            out.flush();
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            out.write("{\"success\": false, \"message\": \"Passwords do not match.\"}");
            out.flush();
            return;
        }

        byte[] newSalt = PasswordUtils.generateSalt();
        String newHashedPassword = PasswordUtils.hashPassword(newPassword, newSalt);
        userDAO.updatePasswordByEmail(loggedUser.getEmail(), newHashedPassword, newSalt);

        out.write("{\"success\": true, \"message\": \"Password changed successfully.\"}");
        out.flush();
    }

    private void handleVerifyEmail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String enteredOtp = request.getParameter("otp");
        String sessionOtp = (String) session.getAttribute("otp");

        PrintWriter out = response.getWriter();

        // Kiểm tra OTP nhập vào
        if (enteredOtp != null && enteredOtp.equals(sessionOtp)) {
            String username = (String) session.getAttribute("username");
            String lastname = (String) session.getAttribute("lastname");
            String firstname = (String) session.getAttribute("firstname");
            String email = (String) session.getAttribute("email");
            String hashedPassword = (String) session.getAttribute("hashedPassword");
            byte[] salt = (byte[]) session.getAttribute("salt");

            Role role = new Role(2, "User");
            User newUser = new User(username, lastname, firstname, hashedPassword, salt, email, role, Paths.AVATAR_DEFAULT);

            int userId = userDAO.registerUser(newUser);
            if (userId > 0) {
                session.removeAttribute("otp");
                out.write("{\"success\": true, \"message\": \"OTP verified successfully. Redirecting...\"}");
                out.flush();
            } else {
                out.write("{\"success\": false, \"message\": \"Registration failed.\"}");
                out.flush();
            }
        } else {
            out.write("{\"success\": false, \"message\": \"Invalid OTP.\"}");
            out.flush();
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (!userDAO.isUsernameTaken(username)) {
            out.write("{\"success\": false, \"message\": \"Username does not exist.\"}");
            out.flush();
            return;
        }

        User dbUser = userDAO.getUserByUsername(username);

        if (!PasswordUtils.verifyPassword(password, dbUser.getStoredSalt(), dbUser.getPasswordHash())) {
            out.write("{\"success\": false, \"message\": \"Invalid password! Please try again.\"}");
            out.flush();
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("user", dbUser);

        Map<Integer, List<Room>> selectedRooms = new HashMap<>();

        session.setAttribute("selectedRooms", selectedRooms);

        boolean isAdmin = (dbUser.getRole().getRoleId() == 1);
        out.write("{\"success\": true, \"message\": \"Login successful. Redirecting...\", \"isAdmin\": " + isAdmin + "}");
        out.flush();
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
            request.getRequestDispatcher("/").forward(request, response);
        } else {
            response.getWriter().println("No user is logged in.");
        }
    }

    private void handleGoogleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("OKKKKKKKKKKKKKKKKKKKK");
        String code = request.getParameter("code");
        if (code == null || code.isEmpty()) {
            System.out.println("Code is null");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Google login request.");
            return;
        }
    }
}

//        try {
            // Lấy access token từ Google
//            String accessToken = GoogleUtils.getToken(code);
//            User googleUser = GoogleUtils.getUserInfo(accessToken);

            // Kiểm tra email trong hệ thống
//            User existingUser = userDAO.getUserByEmail(googleUser.getEmail());
//
//            if (existingUser != null) {
//                // Nếu tài khoản đã tồn tại, cập nhật google_id nếu chưa có
//                if (existingUser.getGoogleId() == null) {
//                    existingUser.setGoogleId(googleUser.getGoogleId());
//                    userDAO.updateUserGoogleId(existingUser);
//                }
//
//                // Đăng nhập
//                HttpSession session = request.getSession();
//                session.setAttribute("user", existingUser);
//                Map<Integer, List<Room>> selectedRooms = new HashMap<>();
//
//                session.setAttribute("selectedRooms", selectedRooms);
//                request.getRequestDispatcher("/").forward(request, response);
//            } else {
//                // Nếu chưa có tài khoản, tạo mới
//                googleUser.setRole(new Role(2, "User")); // Mặc định role là User
//
//                int newUserId = userDAO.registerUser(googleUser);
//                if (newUserId > 0) {
//                    HttpSession session = request.getSession();
//                    session.setAttribute("user", googleUser);
//                    Map<Integer, List<Room>> selectedRooms = new HashMap<>();
//
//                    session.setAttribute("selectedRooms", selectedRooms);
//
//                    request.getRequestDispatcher("/").forward(request, response);
//                } else {
//                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to register Google account.");
//                }
//            }
//        } catch (Exception e) {
//            Logger.getLogger(AuthController.class.getName()).log(Level.SEVERE, null, e);
//            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Google authentication failed.");
//        }
//    }
//}
