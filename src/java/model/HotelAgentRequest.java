package model;

import java.util.List;
import java.sql.Timestamp;

public class HotelAgentRequest {

    private int requestId;
    private int userId;
    private String hotelName;
    private List<String> businessLicenseUrls;
    private String businessLicenseUrlsString;
    private String address;
    private String description;
    private String requestStatus;
    private String requestType;
    private Timestamp submittedAt;
    private String rejectionReason;

    // Getters và Setters
    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public String getBusinessLicenseUrlsString() {
        return businessLicenseUrlsString;
    }

    public void setBusinessLicenseUrlsString(String businessLicenseUrlsString) {
        this.businessLicenseUrlsString = businessLicenseUrlsString;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getHotelName() {
        return hotelName;
    }

    public void setHotelName(String hotelName) {
        this.hotelName = hotelName;
    }

    public List<String> getBusinessLicenseUrls() {
        return businessLicenseUrls;
    }

    public void setBusinessLicenseUrls(List<String> businessLicenseUrls) {
        this.businessLicenseUrls = businessLicenseUrls;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getRequestStatus() {
        return requestStatus;
    }

    public void setRequestStatus(String requestStatus) {
        this.requestStatus = requestStatus;
    }

    public String getRequestType() {
        return requestType;
    }

    public void setRequestType(String requestType) {
        this.requestType = requestType;
    }

    public Timestamp getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(Timestamp submittedAt) {
        this.submittedAt = submittedAt;
    }
}
