package dao;

import model.Hotel;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FavoritesDAO {

    // Thêm khách sạn vào danh sách yêu thích
    public boolean addFavorite(int userId, int hotelId) throws SQLException, Exception {
        String sql = "INSERT INTO Favorites (UserId, HotelId) VALUES (?, ?)";
        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, hotelId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            if (e.getSQLState().equals("23000")) { // Duplicate entry (đã tồn tại trong favorites)
                return false;
            }
            throw e;
        }
    }

    // Xóa khách sạn khỏi danh sách yêu thích
    public boolean removeFavorite(int userId, int hotelId) throws SQLException, Exception {
        String sql = "DELETE FROM Favorites WHERE UserId = ? AND HotelId = ?";
        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, hotelId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    // Lấy danh sách khách sạn yêu thích của người dùng
    public List<Hotel> getFavoriteHotels(int userId) throws SQLException, Exception {
        List<Hotel> favoriteHotels = new ArrayList<>();
        String sql = "SELECT h.HotelId, h.HotelName, h.Location, h.Description, h.HotelImageURLs, h.HotelAgentId, h.IsAccepted, h.CreatedAt, h.IsActive "
                + "FROM Favorites f "
                + "JOIN Hotels h ON f.HotelId = h.HotelId "
                + "WHERE f.UserId = ?";
        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Hotel hotel = new Hotel();
                    hotel.setHotelId(rs.getInt("HotelId"));
                    hotel.setHotelName(rs.getString("HotelName"));
                    hotel.setLocation(rs.getString("Location"));
                    hotel.setDescription(rs.getString("Description"));
                    hotel.setHotelImageURLs(rs.getString("HotelImageURLs"));
                    hotel.setHotelAgentId(rs.getInt("HotelAgentId"));
                    hotel.setAccepted(rs.getBoolean("IsAccepted"));
                    hotel.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    hotel.setActive(rs.getBoolean("IsActive"));
                    hotel.setHotelImageURLs(rs.getString("HotelImageURLs"));
                    favoriteHotels.add(hotel);
                }
            }
        }
        return favoriteHotels;
    }
}
