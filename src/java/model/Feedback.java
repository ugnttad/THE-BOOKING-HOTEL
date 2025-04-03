package model;

import java.sql.Timestamp;

public class Feedback {

    private int feedbackId;
    private int userId;
    private int hotelId;
    private int rating;
    private String comment;
    private Timestamp createdAt;
    private Timestamp lastUpdatedAt;

    public Feedback(int feedbackId, int userId, int hotelId, int rating, String comment, Timestamp createdAt, Timestamp lastUpdatedAt) {
        this.feedbackId = feedbackId;
        this.userId = userId;
        this.hotelId = hotelId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
        this.lastUpdatedAt = lastUpdatedAt;
    }
    
    public Feedback() {
        
    }

    // Getters and Setters
    public int getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getHotelId() {
        return hotelId;
    }

    public void setHotelId(int hotelId) {
        this.hotelId = hotelId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getLastUpdatedAt() {
        return lastUpdatedAt;
    }

    public void setLastUpdatedAt(Timestamp lastUpdatedAt) {
        this.lastUpdatedAt = lastUpdatedAt;
    }
}
