package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Feedback;
import java.sql.ResultSet;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FeedbackDAO {

    public void upsertReview(Feedback feedback) throws Exception {
        String sql = "EXEC UpsertReview ?, ?, ?, ?";

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, feedback.getUserId());
            stmt.setInt(2, feedback.getHotelId());
            stmt.setInt(3, feedback.getRating());
            stmt.setString(4, feedback.getComment());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteFeedback(int userId, int hotelId) throws Exception {
        String sql = "DELETE FROM Feedback WHERE UserId = ? AND HotelId = ?";

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, hotelId);

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Feedback> getFeedbacksByHotelId(int hotelId) throws Exception {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT UserId, HotelId, Rating, Comment FROM Feedback WHERE HotelId = ?";

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, hotelId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setUserId(rs.getInt("UserId"));
                feedback.setHotelId(rs.getInt("HotelId"));
                feedback.setRating(rs.getInt("Rating"));
                feedback.setComment(rs.getString("Comment"));
                feedbacks.add(feedback);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return feedbacks;
    }

    public int getTotalReviewsByHotelId(int hotelId) throws Exception {
        String sql = "SELECT COUNT(*) AS TotalReviews FROM Feedback WHERE HotelId = ?";
        int totalReviews = 0;

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, hotelId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                totalReviews = rs.getInt("TotalReviews");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return totalReviews;
    }

    public int getTotalFeedbackByRating(int rating) throws Exception {
        String sql = "EXEC GetTotalFeedbackByRating ?";
        int totalFeedbacks = 0;

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, rating);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                totalFeedbacks = rs.getInt("TotalFeedbacks");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return totalFeedbacks;
    }

    public double getFeedbackPercentageByRatingLevel(int rating) throws Exception {
        String sql = "EXEC GetFeedbackPercentageByRatingLevel ?";
        double percentage = 0.0;

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, rating);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                percentage = rs.getDouble("Percentage");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return percentage;
    }

    public List<Feedback> getAllFeedbacks() throws Exception {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT FeedbackId, UserId, HotelId, Rating, Comment, CreatedAt, LastUpdatedAt FROM Feedback";

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Feedback feedback = new Feedback(
                        rs.getInt("FeedbackId"),
                        rs.getInt("UserId"),
                        rs.getInt("HotelId"),
                        rs.getInt("Rating"),
                        rs.getString("Comment"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getTimestamp("LastUpdatedAt")
                );
                feedbacks.add(feedback);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return feedbacks;
    }

    public static boolean isUserFeedbackOwner(int userId, int feedbackId) throws Exception {
        String sql = "SELECT COUNT(*) AS Count FROM Feedback WHERE FeedbackId = ? AND UserId = ?";
        boolean isOwner = false;

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, feedbackId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                isOwner = rs.getInt("Count") > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return isOwner;
    }

    public boolean hasUserFeedbackForHotel(int userId, int hotelId) throws Exception {
        String sql = "SELECT COUNT(*) AS Count FROM Feedback WHERE UserId = ? AND HotelId = ?";
        boolean hasFeedback = false;

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, hotelId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                hasFeedback = rs.getInt("Count") > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return hasFeedback;
    }

    public int getFeedbackCountByAgentId(int hotelAgentId) throws SQLException, Exception {
        String query = "SELECT COUNT(f.FeedbackId) AS feedbackCount "
                + "FROM Feedback f "
                + "JOIN Hotels h ON f.HotelId = h.HotelId "
                + "WHERE h.HotelAgentId = ?";

        int feedbackCount = 0;

        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, hotelAgentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    feedbackCount = rs.getInt("feedbackCount");
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(HotelDAO.class.getName()).log(Level.SEVERE, "Error calculating feedback count for hotelAgentId: " + hotelAgentId, e);
            throw e;
        }

        Logger.getLogger(HotelDAO.class.getName()).log(Level.INFO, "Feedback count for hotelAgentId " + hotelAgentId + ": " + feedbackCount);
        return feedbackCount;
    }
}
