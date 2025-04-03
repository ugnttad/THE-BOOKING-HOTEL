package dao;

import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import constant.Roles;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Role;

public class UserDAO {

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("UserId"));
        user.setUsername(rs.getString("Username"));
        user.setFirstName(rs.getString("FirstName"));
        user.setLastName(rs.getString("LastName"));
        user.setEmail(rs.getString("Email"));
        user.setPasswordHash(rs.getString("PasswordHash"));
        user.setStoredSalt(rs.getBytes("StoredSalt"));
        user.setGoogleId(rs.getString("GoogleId"));
        user.setPhoneNumber(rs.getString("PhoneNumber"));
        user.setAvatarUrl(rs.getString("AvatarUrl"));
        user.setActive(rs.getBoolean("IsActive"));
        user.setBanned(rs.getBoolean("IsBanned"));
        user.setDeleted(rs.getBoolean("IsDeleted"));
        user.setCreatedAt(rs.getTimestamp("CreatedAt"));

        Role role = new Role(rs.getInt("RoleId"), rs.getString("RoleName"));

        user.setRole(role);

        return user;
    }

    public boolean deleteUser(int userId) throws Exception {
        String sql = "UPDATE Users SET IsDeleted = 1 WHERE UserId = ?";

        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting user: " + userId, e);
            return false;
        }
    }

    public boolean banUser(int userId) throws Exception {
        String sql = "UPDATE Users SET IsBanned = 1, IsActive = 0 WHERE UserId = ? AND IsDeleted = 0";

        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error banning user: " + userId, e);
            return false;
        }
    }

    // Unban user
    public boolean unbanUser(int userId) throws Exception {
        String sql = "UPDATE Users SET IsBanned = 0 WHERE UserId = ? AND IsDeleted = 0";

        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error unbanning user: " + userId, e);
            return false;
        }
    }

    // Update user basic information
    public boolean updateUser(User user) throws Exception {
        String sql = "UPDATE Users SET Username = ?, FirstName = ?, LastName = ?, Email = ?, PhoneNumber = ?, AvatarUrl = ? WHERE UserId = ? AND IsDeleted = 0";

        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getFirstName());
            ps.setString(3, user.getLastName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhoneNumber());
            ps.setString(6, user.getAvatarUrl());
            ps.setInt(7, user.getUserId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating user: " + user.getUserId(), e);
            return false;
        }
    }

    public User getUserById(int userId) throws Exception {
        String sql = "SELECT u.*, r.RoleName FROM Users u JOIN Roles r ON u.RoleId = r.RoleId WHERE u.UserId = ? AND u.IsDeleted = 0";

        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting user by ID: " + userId, e);
        }
        return null;
    }

    public List<User> getAllUsers() throws Exception {
        List<User> users = new ArrayList<>();
        String sql = "SELECT u.*, r.RoleName FROM Users u JOIN Roles r ON u.RoleId = r.RoleId WHERE u.IsDeleted = 0";

        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                users.add(mapUser(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all users", e);
        }
        return users;
    }

    public int registerUser(User user) {
        String sql = "INSERT INTO Users (Username, FirstName, LastName, PasswordHash, StoredSalt, Email, RoleId, AvatarUrl, GoogleId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getFirstName());
            ps.setString(3, user.getLastName());
            ps.setString(4, user.getPasswordHash());
            ps.setBytes(5, user.getStoredSalt());
            ps.setString(6, user.getEmail());
            ps.setInt(7, user.getRole().getRoleId());
            ps.setString(8, user.getAvatarUrl());
            ps.setString(9, user.getGoogleId());

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            System.out.println(e);
            e.printStackTrace();
        }
        return -1;
    }

    public boolean isUsernameTaken(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isEmailTaken(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public User getUserByUsername(String username) throws Exception {
        User user = null;
        String sql = "SELECT * FROM Users WHERE Username = ?";

        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, username);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("UserID"));
                    user.setUsername(rs.getString("Username"));
                    user.setPasswordHash(rs.getString("PasswordHash"));
                    user.setFirstName(rs.getString("FirstName"));
                    user.setLastName(rs.getString("LastName"));
                    user.setEmail(rs.getString("Email"));
                    user.setAvatarUrl(rs.getString("AvatarUrl"));
                    int roleID = rs.getInt("RoleID");
                    switch (roleID) {
                        case 1 ->
                            user.setRole(Roles.ADMIN);
                        case 3 ->
                            user.setRole(Roles.HOTEL_AGENT);
                        default ->
                            user.setRole(Roles.USER);
                    }
                    user.setStoredSalt(rs.getBytes("StoredSalt"));
                    user.setPhoneNumber(rs.getString("PhoneNumber"));
                    user.setCreatedAt(rs.getDate("CreatedAt"));
                    return user;
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error! " + e.getMessage());
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, e);
        }
        return user;
    }

    public static User getUserByUserId(int id) throws Exception {
        User user = null;
        String sql = "SELECT * FROM Users WHERE UserId = ?";

        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("UserID"));
                    user.setUsername(rs.getString("Username"));
                    user.setPasswordHash(rs.getString("PasswordHash"));
                    user.setFirstName(rs.getString("FirstName"));
                    user.setLastName(rs.getString("LastName"));
                    user.setEmail(rs.getString("Email"));
                    user.setAvatarUrl(rs.getString("AvatarUrl"));
                    int roleID = rs.getInt("RoleID");
                    switch (roleID) {
                        case 1 ->
                            user.setRole(Roles.ADMIN);
                        case 3 ->
                            user.setRole(Roles.HOTEL_AGENT);
                        default ->
                            user.setRole(Roles.USER);
                    }
                    user.setStoredSalt(rs.getBytes("StoredSalt"));
                    user.setPhoneNumber(rs.getString("PhoneNumber"));
                    user.setCreatedAt(rs.getDate("CreatedAt"));
                    return user;
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error! " + e.getMessage());
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, e);
        }
        return user;
    }

    public User getUserByEmail(String email) throws Exception {
        User user = null;
        String sql = "SELECT * FROM Users WHERE Email = ?";

        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, email);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("UserID"));
                    user.setUsername(rs.getString("Username"));
                    user.setPasswordHash(rs.getString("PasswordHash"));
                    user.setFirstName(rs.getString("FirstName"));
                    user.setLastName(rs.getString("LastName"));
                    user.setEmail(rs.getString("Email"));
                    user.setAvatarUrl(rs.getString("AvatarUrl"));
                    int roleID = rs.getInt("RoleID");
                    switch (roleID) {
                        case 1 ->
                            user.setRole(Roles.ADMIN);
                        case 3 ->
                            user.setRole(Roles.HOTEL_AGENT);
                        default ->
                            user.setRole(Roles.USER);
                    }
                    user.setStoredSalt(rs.getBytes("StoredSalt"));
                    user.setPhoneNumber(rs.getString("PhoneNumber"));
                    user.setCreatedAt(rs.getDate("CreatedAt"));
                    return user;
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error! " + e.getMessage());
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, e);
        }
        return user;
    }

    public boolean updateUserGoogleId(User user) throws Exception {
        String sql = "UPDATE Users SET GoogleId = ? WHERE UserId = ?";

        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getGoogleId());
            ps.setInt(2, user.getUserId());

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException | ClassNotFoundException e) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, "Error updating GoogleId", e);
        }
        return false;
    }

    public boolean updatePasswordByEmail(String email, String newPasswordHash, byte[] newSalt) throws Exception {
        String sql = "UPDATE Users SET PasswordHash = ?, StoredSalt = ? WHERE Email = ?";
        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setBytes(2, newSalt);
            ps.setString(3, email);

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException | ClassNotFoundException e) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, "Error updating password by email", e);
        }
        return false;
    }

    public boolean updateUserAvatar(String avatarUrl, int userId) throws Exception {
        String sql = "UPDATE Users SET AvatarUrl = ? WHERE UserId = ?";
        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, avatarUrl);
            ps.setInt(2, userId);

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException | ClassNotFoundException e) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, "Error updating avatarUrl by userId", e);
        }
        return false;
    }

    public boolean updateCustomerToHotelAgent(int userId) throws SQLException, Exception {
        String query = "UPDATE Users SET RoleId = 3 WHERE UserId = ? AND RoleId = 2";
        boolean isUpdated = false;

        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                isUpdated = true;
                Logger.getLogger(UserDAO.class.getName()).log(Level.INFO, "Updated user " + userId + " from Customer to Hotel Agent successfully.");
            } else {
                Logger.getLogger(UserDAO.class.getName()).log(Level.WARNING, "No user with UserId " + userId + " and RoleId = 2 found to update.");
            }
        } catch (SQLException e) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, "Error updating user " + userId + " to Hotel Agent", e);
            throw e;
        }

        return isUpdated;
    }
}
