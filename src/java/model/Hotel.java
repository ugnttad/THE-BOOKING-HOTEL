package model;

import java.sql.Timestamp;
import java.util.Date;

public class Hotel {

    private int hotelId;
    private String hotelName;
    private String location;
    private String description;
    private boolean isAccepted;
    private String hotelImageURLs;
    private int hotelAgentId;
    private Date createdAt;
    private double cheapestRoomPrice;
    private Timestamp lastBooked;
    private int bookingCount;
    private double totalRevenue;
    private String agentName;
    private boolean isActive;
    private boolean isFavorite;

    public boolean isFavorite() {
        return isFavorite;
    }

    public void setFavorite(boolean isFavorite) {
        this.isFavorite = isFavorite;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }

    public String getAgentName() {
        return agentName;
    }

    public void setAgentName(String agentName) {
        this.agentName = agentName;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public Timestamp getLastBooked() {
        return lastBooked;
    }

    public void setLastBooked(Timestamp lastBooked) {
        this.lastBooked = lastBooked;
    }

    public int getBookingCount() {
        return bookingCount;
    }

    public void setBookingCount(int bookingCount) {
        this.bookingCount = bookingCount;
    }

    public Hotel() {
    }

    public Hotel(int hotelId, String hotelName, String location, String description,
            boolean isAccepted, String hotelImageURLs, int hotelAgentId, Date createdAt) {
        this.hotelId = hotelId;
        this.hotelName = hotelName;
        this.location = location;
        this.description = description;
        this.isAccepted = isAccepted;
        this.hotelImageURLs = hotelImageURLs;
        this.hotelAgentId = hotelAgentId;
        this.createdAt = createdAt;
    }

    public int getHotelId() {
        return hotelId;
    }

    public void setHotelId(int hotelId) {
        this.hotelId = hotelId;
    }

    public boolean isIsAccepted() {
        return isAccepted;
    }

    public void setIsAccepted(boolean isAccepted) {
        this.isAccepted = isAccepted;
    }

    public double getCheapestRoomPrice() {
        return cheapestRoomPrice;
    }

    public void setCheapestRoomPrice(double cheapestRoomPrice) {
        this.cheapestRoomPrice = cheapestRoomPrice;
    }

    public String getHotelName() {
        return hotelName;
    }

    public void setHotelName(String hotelName) {
        this.hotelName = hotelName;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isAccepted() {
        return isAccepted;
    }

    public void setAccepted(boolean accepted) {
        isAccepted = accepted;
    }

    public String getHotelImageURLs() {
        return hotelImageURLs;
    }

    public void setHotelImageURLs(String hotelImageURLs) {
        this.hotelImageURLs = hotelImageURLs;
    }

    public int getHotelAgentId() {
        return hotelAgentId;
    }

    public void setHotelAgentId(int hotelAgentId) {
        this.hotelAgentId = hotelAgentId;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Hotel{"
                + "hotelId=" + hotelId
                + ", hotelName='" + hotelName + '\''
                + ", location='" + location + '\''
                + ", description='" + description + '\''
                + ", isAccepted=" + isAccepted
                + ", hotelImageURLs='" + hotelImageURLs + '\''
                + ", hotelAgentId=" + hotelAgentId
                + ", createdAt=" + createdAt
                + '}';
    }
}
