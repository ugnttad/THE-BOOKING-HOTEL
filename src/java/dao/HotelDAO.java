package dao;

import java.sql.Timestamp;
import java.util.List;
import model.Hotel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.sql.SQLException;
import model.Role;
import model.User;
import org.json.JSONArray;
import java.util.logging.Level;
import java.util.logging.Logger;

public class HotelDAO {

    private static final double EXCHANGE_RATE_VND_TO_USD = 25336.0;

//    public List<Hotel> getAllHotels() {
//        List<Hotel> hotels = new ArrayList<>();
//        String query = "SELECT * FROM Hotels";
//
//        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = connection.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
//
//            while (rs.next()) {
//                Hotel hotel = new Hotel(
//                        rs.getInt("HotelId"),
//                        rs.getString("HotelName"),
//                        rs.getString("Location"),
//                        rs.getString("Description"),
//                        rs.getBoolean("IsAccepted"),
//                        rs.getString("HotelImageURLs"),
//                        rs.getInt("HotelAgentId"),
//                        rs.getTimestamp("CreatedAt")
//                );
//                hotel.setCheapestRoomPrice(getCheapestRoomPrice(hotel.getHotelId()));
//                hotels.add(hotel);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return hotels;
//    }
//    public List<Hotel> getAllActiveHotels() {
//        List<Hotel> hotels = new ArrayList<>();
//        String query = "SELECT * FROM Hotels WHERE IsAccepted = 1 AND IsActive = 1";
//
//        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = connection.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
//
//            while (rs.next()) {
//                Hotel hotel = new Hotel(
//                        rs.getInt("HotelId"),
//                        rs.getString("HotelName"),
//                        rs.getString("Location"),
//                        rs.getString("Description"),
//                        rs.getBoolean("IsAccepted"),
//                        rs.getString("HotelImageURLs"),
//                        rs.getInt("HotelAgentId"),
//                        rs.getTimestamp("CreatedAt")
//                );
//                hotel.setCheapestRoomPrice(getCheapestRoomPrice(hotel.getHotelId()));
//                hotel.setActive(rs.getBoolean("IsActive"));
//                hotels.add(hotel);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return hotels;
//    }
    
    public List<Hotel> getAllActiveHotels(int userId) {
        List<Hotel> hotels = new ArrayList<>();
        String query = "SELECT h.*, "
                + "(SELECT CASE WHEN EXISTS (SELECT 1 FROM Favorites f WHERE f.HotelId = h.HotelId AND f.UserId = ?) THEN 1 ELSE 0 END) AS IsFavorite "
                + "FROM Hotels h WHERE h.IsAccepted = 1 AND h.IsActive = 1";

        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Hotel hotel = new Hotel(
                            rs.getInt("HotelId"),
                            rs.getString("HotelName"),
                            rs.getString("Location"),
                            rs.getString("Description"),
                            rs.getBoolean("IsAccepted"),
                            rs.getString("HotelImageURLs"),
                            rs.getInt("HotelAgentId"),
                            rs.getTimestamp("CreatedAt")
                    );
                    hotel.setCheapestRoomPrice(getCheapestRoomPrice(hotel.getHotelId()));
                    hotel.setActive(rs.getBoolean("IsActive"));
                    hotel.setFavorite(rs.getBoolean("IsFavorite"));
                    hotels.add(hotel);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return hotels;
    }

    public List<Hotel> getTopHotelsByBookings(int userId, int limit) throws SQLException, Exception {
        List<Hotel> hotels = new ArrayList<>();
        String sql = "SELECT TOP (?) h.HotelId, h.HotelName, h.Location, "
                + "h.HotelImageURLs, MIN(r.PricePerNight) AS CheapestRoomPrice, "
                + "u.Username AS AgentName, COUNT(b.BookingId) AS BookingCount, "
                + "(SELECT CASE WHEN EXISTS (SELECT 1 FROM Favorites f WHERE f.HotelId = h.HotelId AND f.UserId = ?) THEN 1 ELSE 0 END) AS IsFavorite "
                + "FROM Hotels h "
                + "LEFT JOIN Rooms r ON h.HotelId = r.HotelId "
                + "LEFT JOIN Bookings b ON r.RoomId = b.RoomId AND b.BookingStatus = 'Completed' "
                + "JOIN Users u ON h.HotelAgentId = u.UserId "
                + "WHERE h.IsActive = 1 AND h.IsAccepted = 1 "
                + "GROUP BY h.HotelId, h.HotelName, h.Location, h.HotelImageURLs, u.Username "
                + "ORDER BY BookingCount DESC";

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit); // Giới hạn số lượng khách sạn
            stmt.setInt(2, userId); // ID của người dùng để kiểm tra Favorites
            Logger.getLogger(HotelDAO.class.getName()).log(Level.INFO,
                    "Executing SQL: " + sql.replace("?", String.valueOf(limit)) + " with userId: " + userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Hotel hotel = new Hotel();
                    hotel.setHotelId(rs.getInt("HotelId"));
                    hotel.setHotelName(rs.getString("HotelName"));
                    hotel.setLocation(rs.getString("Location"));
                    hotel.setHotelImageURLs(rs.getString("HotelImageURLs"));
                    hotel.setCheapestRoomPrice(rs.getDouble("CheapestRoomPrice"));
                    hotel.setAgentName(rs.getString("AgentName"));
                    hotel.setFavorite(rs.getBoolean("IsFavorite")); // Gán trạng thái yêu thích
                    hotels.add(hotel);
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(HotelDAO.class.getName()).log(Level.SEVERE,
                    "Error fetching top hotels by bookings", e);
            throw e;
        }
        Logger.getLogger(HotelDAO.class.getName()).log(Level.INFO,
                "Retrieved " + hotels.size() + " top hotels for userId: " + userId);
        return hotels;
    }

    public int getHotelCountByAgentId(int hotelAgentId) throws SQLException, Exception {
        String query = "SELECT COUNT(hotelId) AS hotelCount "
                + "FROM Hotels "
                + "WHERE hotelAgentId = ?";

        int hotelCount = 0;

        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, hotelAgentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    hotelCount = rs.getInt("hotelCount");
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(HotelDAO.class.getName()).log(Level.SEVERE, "Error getting hotel count for hotelAgentId: " + hotelAgentId, e);
            throw e;
        }

        Logger.getLogger(HotelDAO.class.getName()).log(Level.INFO, "Hotel count for hotelAgentId " + hotelAgentId + ": " + hotelCount);
        return hotelCount;
    }

    public List<Hotel> searchHotels(String location, Date checkIn, Date checkOut, int guests, int rooms) throws Exception {
        List<Hotel> hotels = new ArrayList<>();
        String sql = "EXEC SearchHotels ?, ?, ?, ?, ?";
        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, location);
            stmt.setDate(2, (java.sql.Date) checkIn);
            stmt.setDate(3, (java.sql.Date) checkOut);
            stmt.setInt(4, guests);
            stmt.setInt(5, rooms);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Hotel hotel = new Hotel();
                hotel.setHotelId(rs.getInt("HotelId"));
                hotel.setHotelName(rs.getString("HotelName"));
                hotel.setLocation(rs.getString("Location"));
                hotel.setDescription(rs.getString("Description"));
                hotel.setHotelImageURLs(rs.getString("HotelImageURLs"));
                hotel.setCheapestRoomPrice(getCheapestRoomPrice(hotel.getHotelId()));
                hotels.add(hotel);
            }
            System.out.println(hotels.size() + "hotels");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return hotels;
    }

    public List<Hotel> filterHotels(String hotelName, String roomTypes, String facilities, String mealPlans, Integer minRating) throws Exception {
        List<Hotel> hotels = new ArrayList<>();
        String sql = "EXEC FilterHotels ?, ?, ?, ?, ?";

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, hotelName);
            stmt.setString(2, roomTypes);
            stmt.setString(3, facilities);
            stmt.setString(4, mealPlans);
            stmt.setObject(5, minRating, java.sql.Types.INTEGER);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Hotel hotel = new Hotel();
                hotel.setHotelId(rs.getInt("HotelId"));
                hotel.setHotelName(rs.getString("HotelName"));
                hotel.setLocation(rs.getString("Location"));
                hotel.setDescription(rs.getString("Description"));
                hotel.setHotelImageURLs(rs.getString("HotelImageURLs"));
                hotel.setCheapestRoomPrice(getCheapestRoomPrice(hotel.getHotelId()));

                hotels.add(hotel);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return hotels;
    }

    private Double getCheapestRoomPrice(int hotelId) throws Exception {
        String sql = "EXEC GetCheapestRoomPrice ?";
        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, hotelId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("PricePerNight");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public User getHotelAgentDetails(int hotelId) throws Exception {
        User agent = null;
        String query = "EXEC GetHotelAgentDetails ?";

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, hotelId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                agent = new User();
                agent.setUserId(rs.getInt("UserId"));
                agent.setFirstName(rs.getString("FirstName"));
                agent.setLastName(rs.getString("LastName"));
                agent.setEmail(rs.getString("Email"));
                agent.setPhoneNumber(rs.getString("PhoneNumber"));
                agent.setAvatarUrl(rs.getString("AvatarUrl"));
                agent.setRole(new Role(3, rs.getString("RoleName")));
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return agent;
    }

    public int getTotalFeedbackForHotel(int hotelId) throws Exception {
        String sql = "EXEC GetTotalFeedbackForHotel ?";
        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, hotelId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("TotalFeedback");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Double getAverageHotelRating(int hotelId) throws Exception {
        String sql = "EXEC GetAverageHotelRating ?";
        Double averageRating = 0.0;

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, hotelId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                averageRating = rs.getDouble("AverageRating");
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return averageRating;
    }

    public Hotel getHotelById(int hotelId) throws Exception {
        Hotel hotel = null;
        String query = "SELECT * FROM Hotels WHERE HotelId = ?";

        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = connection.prepareStatement(query)) {

            stmt.setInt(1, hotelId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                hotel = new Hotel(
                        rs.getInt("HotelId"),
                        rs.getString("HotelName"),
                        rs.getString("Location"),
                        rs.getString("Description"),
                        rs.getBoolean("IsAccepted"),
                        rs.getString("HotelImageURLs"),
                        rs.getInt("HotelAgentId"),
                        rs.getTimestamp("CreatedAt")
                );
                hotel.setCheapestRoomPrice(getCheapestRoomPrice(hotel.getHotelId()));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return hotel;
    }

    public List<Hotel> getHotelsByHotelAgentId(int hotelAgentId) throws Exception {
        List<Hotel> hotels = new ArrayList<>();
        String query = "SELECT * FROM Hotels WHERE HotelAgentId = ?";

        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = connection.prepareStatement(query)) {

            stmt.setInt(1, hotelAgentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Hotel hotel = new Hotel(
                            rs.getInt("HotelId"),
                            rs.getString("HotelName"),
                            rs.getString("Location"),
                            rs.getString("Description"),
                            rs.getBoolean("IsAccepted"),
                            rs.getString("HotelImageURLs"),
                            rs.getInt("HotelAgentId"),
                            rs.getTimestamp("CreatedAt")
                    );
                    hotel.setActive(rs.getBoolean("IsActive"));
                    hotel.setCheapestRoomPrice(getCheapestRoomPrice(hotel.getHotelId()));
                    hotels.add(hotel);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e; // Ném ngoại lệ để xử lý ở tầng trên nếu cần
        }
        return hotels;
    }

    public int getTotalRoomsForHotel(int hotelId) throws Exception {
        String sql = "EXEC GetTotalRoomsByHotelID ?";
        int totalRooms = 0;

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, hotelId);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                totalRooms = rs.getInt("TotalRooms");
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return totalRooms;
    }

    public int addHotel(String hotelName, String description, String country, String city, String address, int hotelAgentId, List<String> imageUrls) throws SQLException, Exception {
        String sql = "INSERT INTO Hotels (HotelName, Location, Description, IsAccepted, HotelImageURLs, HotelAgentId) VALUES (?, ?, ?, ?, ?, ?)";

        // Nối chuỗi location từ address, city, country (bỏ qua giá trị null)
        StringBuilder locationBuilder = new StringBuilder();
        if (address != null && !address.trim().isEmpty()) {
            locationBuilder.append(address.trim());
        }
        if (city != null && !city.trim().isEmpty()) {
            if (locationBuilder.length() > 0) {
                locationBuilder.append(", ");
            }
            locationBuilder.append(city.trim());
        }
        if (country != null && !country.trim().isEmpty()) {
            if (locationBuilder.length() > 0) {
                locationBuilder.append(", ");
            }
            locationBuilder.append(country.trim());
        }
        String location = locationBuilder.length() > 0 ? locationBuilder.toString() : null;

        // Chuyển danh sách imageUrls thành chuỗi JSON
        String imageUrlsJson = imageUrls != null && !imageUrls.isEmpty() ? new org.json.JSONArray(imageUrls).toString() : null;

        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, hotelName);
            ps.setString(2, location);
            ps.setString(3, description);
            ps.setBoolean(4, false); // IsAccepted mặc định là false
            ps.setString(5, imageUrlsJson);
            ps.setInt(6, hotelAgentId);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1); // Trả về HotelId vừa thêm
                    }
                }
            }
            return -1; // Trả về -1 nếu không thêm được
        } catch (SQLException e) {
            throw e; // Ném ngoại lệ để xử lý ở tầng trên
        }
    }

    public void addHotelServices(int hotelId, List<String> serviceIds) throws SQLException, Exception {
        String sql = "INSERT INTO Hotel_HotelService (HotelId, ServiceId) VALUES (?, ?)";
        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (String serviceId : serviceIds) {
                ps.setInt(1, hotelId);
                ps.setInt(2, Integer.parseInt(serviceId));
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    public List<Integer> getHotelServiceIds(int hotelId) throws SQLException, Exception {
        String query = "SELECT ServiceId FROM Hotel_HotelService WHERE HotelId = ?";
        List<Integer> serviceIds = new ArrayList<>();

        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, hotelId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    serviceIds.add(rs.getInt("ServiceId"));
                }
            }
        }
        return serviceIds;
    }

    // Cập nhật hotel
    public boolean updateHotel(int hotelId, String hotelName, String hotelDescription, String country, String city,
            String address, List<String> serviceIds, List<String> imageUrls) throws SQLException, Exception {
        String updateHotelSql = "UPDATE Hotels SET HotelName = ?, Description = ?, Location = ?, HotelImageURLs = ? WHERE HotelId = ?";
        String deleteServicesSql = "DELETE FROM Hotel_HotelService WHERE HotelId = ?";
        String insertServiceSql = "INSERT INTO Hotel_HotelService (HotelId, ServiceId) VALUES (?, ?)";

        Connection connection = null;
        PreparedStatement psUpdate = null;
        PreparedStatement psDelete = null;
        PreparedStatement psInsert = null;

        try {
            connection = JDBC.getConnectionWithSqlJdbc();
            connection.setAutoCommit(false);

            // Nối chuỗi location
            StringBuilder locationBuilder = new StringBuilder();
            if (address != null && !address.trim().isEmpty()) {
                locationBuilder.append(address.trim());
            }
            if (city != null && !city.trim().isEmpty()) {
                if (locationBuilder.length() > 0) {
                    locationBuilder.append(", ");
                }
                locationBuilder.append(city.trim());
            }
            if (country != null && !country.trim().isEmpty()) {
                if (locationBuilder.length() > 0) {
                    locationBuilder.append(", ");
                }
                locationBuilder.append(country.trim());
            }
            String location = locationBuilder.length() > 0 ? locationBuilder.toString() : null;

            // Cập nhật thông tin hotel
            psUpdate = connection.prepareStatement(updateHotelSql);
            psUpdate.setString(1, hotelName);
            psUpdate.setString(2, hotelDescription);
            psUpdate.setString(3, location);
            psUpdate.setString(4, new JSONArray(imageUrls).toString());
            psUpdate.setInt(5, hotelId);
            int rowsAffected = psUpdate.executeUpdate();

            if (rowsAffected == 0) {
                connection.rollback();
                return false;
            }

            // Xóa dịch vụ cũ
            psDelete = connection.prepareStatement(deleteServicesSql);
            psDelete.setInt(1, hotelId);
            psDelete.executeUpdate();

            // Thêm dịch vụ mới
            if (!serviceIds.isEmpty()) {
                psInsert = connection.prepareStatement(insertServiceSql);
                for (String serviceId : serviceIds) {
                    psInsert.setInt(1, hotelId);
                    psInsert.setInt(2, Integer.parseInt(serviceId));
                    psInsert.addBatch();
                }
                psInsert.executeBatch();
            }

            connection.commit();
            return true;
        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (psUpdate != null) {
                psUpdate.close();
            }
            if (psDelete != null) {
                psDelete.close();
            }
            if (psInsert != null) {
                psInsert.close();
            }
            if (connection != null) {
                connection.close();
            }
        }
    }

    public List<Hotel> getRecentlyBookedHotelsByAgentId(int hotelAgentId) throws SQLException, Exception {
        String query = "SELECT TOP 5 h.HotelId, h.HotelName, h.HotelImageURLs, "
                + "MAX(b.CreatedAt) AS LastBooked, "
                + "COUNT(CASE WHEN b.BookingStatus = 'Completed' THEN b.BookingId END) AS BookingCount "
                + "FROM Hotels h "
                + "LEFT JOIN Rooms r ON h.HotelId = r.HotelId "
                + "LEFT JOIN Bookings b ON r.RoomId = b.RoomId "
                + "WHERE h.HotelAgentId = ? "
                + "GROUP BY h.HotelId, h.HotelName, h.HotelImageURLs "
                + "ORDER BY MAX(b.CreatedAt) DESC";

        List<Hotel> hotels = new ArrayList<>();

        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, hotelAgentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Hotel hotel = new Hotel();
                    hotel.setHotelId(rs.getInt("HotelId"));
                    hotel.setHotelName(rs.getString("HotelName"));
                    String imageURLs = rs.getString("HotelImageURLs");
                    if (imageURLs != null && !imageURLs.isEmpty()) {
                        if (imageURLs.startsWith("[")) {
                            // Xử lý JSON: ["url1.jpg", "url2.jpg"] hoặc ["url1.jpg"]
                            int firstQuoteEnd = imageURLs.indexOf("\"", 1); // Tìm dấu " đầu tiên sau [
                            int secondQuoteStart = imageURLs.indexOf("\"", firstQuoteEnd + 1); // Tìm dấu " tiếp theo
                            if (firstQuoteEnd != -1 && secondQuoteStart != -1) {
                                String firstImage = imageURLs.substring(firstQuoteEnd + 1, secondQuoteStart);
                                hotel.setHotelImageURLs(firstImage);
                            } else {
                                hotel.setHotelImageURLs(""); // Nếu JSON không hợp lệ, để trống
                            }
                        } else {
                            hotel.setHotelImageURLs(imageURLs); // Không phải JSON, dùng nguyên chuỗi
                        }
                    }
                    Timestamp lastBooked = rs.getTimestamp("LastBooked");
                    hotel.setLastBooked(lastBooked);
                    hotel.setBookingCount(rs.getInt("BookingCount"));
                    hotels.add(hotel);
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(HotelDAO.class.getName()).log(Level.SEVERE, "Error fetching recently booked hotels for hotelAgentId: " + hotelAgentId, e);
            throw e;
        }

        Logger.getLogger(HotelDAO.class.getName()).log(Level.INFO, "Recently booked hotels for hotelAgentId " + hotelAgentId + ": " + hotels.size() + " hotels");
        return hotels;
    }

    public List<Hotel> getAllHotelsWithRevenue() throws SQLException, Exception {
        List<Hotel> hotels = new ArrayList<>();
        String sql = "SELECT h.HotelId, h.HotelName, h.Location, "
                + "COALESCE(SUM(b.TotalAmount) / ?, 0) AS TotalRevenue, "
                + "u.Username AS AgentName, h.IsActive, h.IsAccepted "
                + "FROM Hotels h "
                + "LEFT JOIN Rooms r ON h.HotelId = r.HotelId "
                + "LEFT JOIN Bookings b ON r.RoomId = b.RoomId AND b.BookingStatus = 'Completed' "
                + "JOIN Users u ON h.HotelAgentId = u.UserId "
                + "GROUP BY h.HotelId, h.HotelName, h.Location, u.Username, h.IsActive, h.IsAccepted "
                + "ORDER BY TotalRevenue DESC";

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDouble(1, EXCHANGE_RATE_VND_TO_USD);
            Logger.getLogger(HotelDAO.class.getName()).log(Level.INFO, "Executing SQL: " + sql.replace("?", String.valueOf(EXCHANGE_RATE_VND_TO_USD)));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Hotel hotel = new Hotel();
                    hotel.setHotelId(rs.getInt("HotelId"));
                    hotel.setHotelName(rs.getString("HotelName"));
                    hotel.setLocation(rs.getString("Location"));
                    hotel.setTotalRevenue(rs.getDouble("TotalRevenue"));
                    hotel.setAgentName(rs.getString("AgentName"));
                    hotel.setActive(rs.getBoolean("IsActive"));
                    hotel.setAccepted(rs.getBoolean("IsAccepted"));
                    hotels.add(hotel);
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(HotelDAO.class.getName()).log(Level.SEVERE, "Error fetching hotels with revenue", e);
            throw e;
        }

        Logger.getLogger(HotelDAO.class.getName()).log(Level.INFO, "Retrieved " + hotels.size() + " hotels");
        return hotels;
    }

    // Get agent details by HotelAgentId
    public User getAgentDetailsById(int hotelAgentId) throws SQLException, Exception {
        String sql = "SELECT UserId, Username, Email, LastName, FirstName, PhoneNumber "
                + "FROM Users WHERE UserId = ?";
        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, hotelAgentId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                User agent = new User();
                agent.setUserId(rs.getInt("UserId"));
                agent.setUsername(rs.getString("Username"));
                agent.setEmail(rs.getString("Email"));
                agent.setLastName(rs.getString("LastName"));
                agent.setFirstName(rs.getString("FirstName"));
                agent.setPhoneNumber(rs.getString("PhoneNumber"));
                return agent;
            }
        } catch (SQLException e) {
            Logger.getLogger(HotelDAO.class.getName()).log(Level.SEVERE, "Error fetching agent details", e);
            throw e;
        }
        return null;
    }

    public boolean banHotel(int hotelId) throws SQLException, Exception {
        String sql = "UPDATE Hotels SET isActive = 0 WHERE HotelId = ?";
        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, hotelId);
            int rowsAffected = ps.executeUpdate();
            Logger.getLogger(HotelDAO.class.getName()).log(Level.INFO,
                    "Banned hotel with HotelId: {0}, Rows affected: {1}",
                    new Object[]{hotelId, rowsAffected});
            return rowsAffected > 0;
        }
    }

    // Unban hotel
    public boolean unbanHotel(int hotelId) throws SQLException, Exception {
        String sql = "UPDATE Hotels SET isActive = 1 WHERE HotelId = ?";
        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, hotelId);
            int rowsAffected = ps.executeUpdate();
            Logger.getLogger(HotelDAO.class.getName()).log(Level.INFO,
                    "Unbanned hotel with HotelId: {0}, Rows affected: {1}",
                    new Object[]{hotelId, rowsAffected});
            return rowsAffected > 0;
        }
    }

    public boolean acceptHotel(int hotelId) throws SQLException, Exception {
        String sql = "UPDATE Hotels SET isAccepted = 1, isActive = 1 WHERE HotelId = ? AND isAccepted = 0";
        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, hotelId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
}
