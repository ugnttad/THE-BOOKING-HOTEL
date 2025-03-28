package controller;

import dao.FeedbackDAO;
import model.Feedback;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "FeedbackController", urlPatterns = {"/feedback"})
@MultipartConfig
public class FeedbackController extends HttpServlet {

    private final FeedbackDAO feedbackDAO = new FeedbackDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("list".equalsIgnoreCase(action)) {
            try {
                listFeedbacks(request, response);
            } catch (Exception ex) {
                Logger.getLogger(FeedbackController.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("upsert".equalsIgnoreCase(action)) {
            try {
                upsertFeedback(request, response);
            } catch (Exception ex) {
                Logger.getLogger(FeedbackController.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            try {
                deleteFeedback(request, response);
            } catch (Exception ex) {
                Logger.getLogger(FeedbackController.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    private void listFeedbacks(HttpServletRequest request, HttpServletResponse response) throws IOException, Exception {
        int hotelId = Integer.parseInt(request.getParameter("hotelId"));

        List<Feedback> feedbacks = feedbackDAO.getFeedbacksByHotelId(hotelId);
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        out.print("[");
        for (int i = 0; i < feedbacks.size(); i++) {
            Feedback f = feedbacks.get(i);
            out.print("{ \"userId\": " + f.getUserId()
                    + ", \"rating\": " + f.getRating()
                    + ", \"comment\": \"" + f.getComment() + "\" }");
            if (i < feedbacks.size() - 1) {
                out.print(",");
            }
        }
        out.print("]");
        out.flush();
    }

    private void upsertFeedback(HttpServletRequest request, HttpServletResponse response) throws IOException, Exception {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            // Check if user is logged in
            if (user == null) {
                // Return JSON with failure message
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Error: User is not logged in.\"}");
                response.getWriter().flush();
                return;
            }

            int userId = user.getUserId();
            String comment = request.getParameter("comment");
            int hotelId = Integer.parseInt(request.getParameter("hotelId"));
            int rating = Integer.parseInt(request.getParameter("rating"));

            // Create feedback object
            Feedback feedback = new Feedback();
            feedback.setUserId(userId);
            feedback.setHotelId(hotelId);
            feedback.setRating(rating);
            feedback.setComment(comment);

            // Save feedback to the database
            feedbackDAO.upsertReview(feedback);

            // Return success message
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true, \"message\": \"Your review has been submitted successfully.\"}");
            response.getWriter().flush();

        } catch (NumberFormatException e) {
            // Handle invalid number format error
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Error: Invalid number format.\"}");
            response.getWriter().flush();
        } catch (Exception e) {
            // Handle general errors
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Error: Something went wrong.\"}");
            response.getWriter().flush();
        }
    }

    private void deleteFeedback(HttpServletRequest request, HttpServletResponse response) throws IOException, Exception {
        int userId = Integer.parseInt(request.getParameter("userId"));
        int hotelId = Integer.parseInt(request.getParameter("hotelId"));

        feedbackDAO.deleteFeedback(userId, hotelId);

        response.getWriter().write("Feedback has been deleted.");
    }
}
