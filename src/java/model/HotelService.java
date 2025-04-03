package model;

public class HotelService {
    private int serviceId;
    private String serviceName;
    private double hotelServiceEstimatedPrice;
    private String hotelServiceDescription;

    // Constructor
    public HotelService(int serviceId, String serviceName, double hotelServiceEstimatedPrice, String hotelServiceDescription) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.hotelServiceEstimatedPrice = hotelServiceEstimatedPrice;
        this.hotelServiceDescription = hotelServiceDescription;
    }

    // Getters and Setters
    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public double getHotelServiceEstimatedPrice() {
        return hotelServiceEstimatedPrice;
    }

    public void setHotelServiceEstimatedPrice(double hotelServiceEstimatedPrice) {
        this.hotelServiceEstimatedPrice = hotelServiceEstimatedPrice;
    }

    public String getHotelServiceDescription() {
        return hotelServiceDescription;
    }

    public void setHotelServiceDescription(String hotelServiceDescription) {
        this.hotelServiceDescription = hotelServiceDescription;
    }

    @Override
    public String toString() {
        return "HotelService{" +
                "serviceId=" + serviceId +
                ", serviceName='" + serviceName + '\'' +
                ", hotelServiceEstimatedPrice=" + hotelServiceEstimatedPrice +
                ", hotelServiceDescription='" + hotelServiceDescription + '\'' +
                '}';
    }
}