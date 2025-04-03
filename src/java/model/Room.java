package model;

import java.io.Serializable;
import java.util.Objects;

public class Room implements Serializable {

    private static final long serialVersionUID = 1L;

    private int roomId;
    private int hotelId;
    private String roomNumber;
    private String roomDescription;
    private int roomTypeId;
    private double pricePerNight;
    private int capacity;
    private boolean isAvailable;
    private String roomTypeName;
    private String roomImageURLs;

    // Constructor
    public Room(int roomId, int hotelId, String roomNumber, String roomDescription,
            int roomTypeId, String roomTypeName, double pricePerNight, int capacity, boolean isAvailable) {
        this.roomId = roomId;
        this.hotelId = hotelId;
        this.roomNumber = roomNumber;
        this.roomDescription = roomDescription;
        this.roomTypeId = roomTypeId;
        this.roomTypeName = roomTypeName;
        this.pricePerNight = pricePerNight;
        this.capacity = capacity;
        this.isAvailable = isAvailable;
    }

    // Getter and Setter methods
    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getHotelId() {
        return hotelId;
    }

    public void setHotelId(int hotelId) {
        this.hotelId = hotelId;
    }

    public String getRoomImageURLs() {
        return roomImageURLs;
    }

    public void setRoomImageURLs(String roomImageURLs) {
        this.roomImageURLs = roomImageURLs;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public String getRoomDescription() {
        return roomDescription;
    }

    public void setRoomDescription(String roomDescription) {
        this.roomDescription = roomDescription;
    }

    public int getRoomTypeId() {
        return roomTypeId;
    }

    public void setRoomTypeId(int roomTypeId) {
        this.roomTypeId = roomTypeId;
    }

    public double getPricePerNight() {
        return pricePerNight;
    }

    public void setPricePerNight(double pricePerNight) {
        this.pricePerNight = pricePerNight;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public boolean isAvailable() {
        return isAvailable;
    }

    public void setAvailable(boolean available) {
        isAvailable = available;
    }

    public String getRoomTypeName() {
        return roomTypeName;
    }

    public void setRoomTypeName(String roomTypeName) {
        this.roomTypeName = roomTypeName;
    }

    @Override
    public String toString() {
        return "Room{"
                + "roomId=" + roomId
                + ", hotelId=" + hotelId
                + ", roomNumber='" + roomNumber + '\''
                + ", roomDescription='" + roomDescription + '\''
                + ", roomTypeId=" + roomTypeId
                + ", roomTypeName='" + roomTypeName + '\''
                + ", pricePerNight=" + pricePerNight
                + ", capacity=" + capacity
                + ", isAvailable=" + isAvailable
                + '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        Room room = (Room) o;
        return roomId == room.roomId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(roomId);
    }
}
