package model;

import java.util.Date;

public class User {

    private int userId;
    private String username;
    private String lastName;
    private String firstName;
    private String passwordHash;
    private byte[] storedSalt;
    private String email;
    private Role role;
    private String avatarUrl;
    private String googleId;
    private String phoneNumber;
    private Date CreatedAt;
    private boolean isActive;
    private boolean isBanned;
    private boolean isDeleted;

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        this.isActive = active;
    }

    public boolean isBanned() {
        return isBanned;
    }

    public void setBanned(boolean banned) {
        this.isBanned = banned;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean deleted) {
        this.isDeleted = deleted;
    }

    public Date getCreatedAt() {
        return CreatedAt;
    }

    public void setCreatedAt(Date CreatedAt) {
        this.CreatedAt = CreatedAt;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getGoogleId() {
        return googleId;
    }

    public void setGoogleId(String googleId) {
        this.googleId = googleId;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public byte[] getStoredSalt() {
        return storedSalt;
    }

    public void setStoredSalt(byte[] storedSalt) {
        this.storedSalt = storedSalt;
    }

    public User() {
        this.username = "";
        this.lastName = "";
        this.firstName = "";
        this.passwordHash = "";
        this.storedSalt = null;
        this.email = "";
        this.role = null;
        this.avatarUrl = "";
    }

    public User(String username, String lastName, String firstName, String passwordHash, byte[] storedSalt, String email, Role role, String avatarUrl) {
        this.username = username;
        this.lastName = lastName;
        this.firstName = firstName;
        this.passwordHash = passwordHash;
        this.storedSalt = storedSalt;
        this.email = email;
        this.role = role;
        this.avatarUrl = avatarUrl;
    }

    @Override
    public String toString() {
        return "User{" + "userId=" + userId + ", username=" + username + ", passwordHash=" + passwordHash + ", email=" + email + ", role=" + role + '}';
    }
}
