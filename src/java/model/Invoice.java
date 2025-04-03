package model;

import java.sql.Timestamp;
import java.util.List;

public class Invoice {

    private int transactionId;
    private List<Booking> bookings;  // List of bookings related to this transaction
    private double totalAmount;
    private User hotelAgent;  // Hotel agent who created the booking

    // Getters and Setters
    public int getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(int transactionId) {
        this.transactionId = transactionId;
    }

    public List<Booking> getBookings() {
        return bookings;
    }

    public void setBookings(List<Booking> bookings) {
        this.bookings = bookings;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public User getHotelAgent() {
        return hotelAgent;
    }

    public void setHotelAgent(User hotelAgent) {
        this.hotelAgent = hotelAgent;
    }
}