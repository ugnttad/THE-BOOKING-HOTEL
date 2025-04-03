package dao;

import java.sql.Timestamp;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Year;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Booking;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BookingDAO {

    private static final double EXCHANGE_RATE_VND_TO_USD = 25336.0;

    public int getLastBookingTransactionId(int userId) throws SQLException, Exception {
        String sql = "SELECT TOP 1 TransactionId FROM BookingTransactions WHERE UserId = ? ORDER BY CreatedAt DESC";
        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("TransactionId");
                }
                return -1;
            }
        }
    }

    public int getHotelAgentIdByHotelId(int hotelId) throws SQLException, Exception {
        String sql = "SELECT HotelAgentId FROM Hotels WHERE HotelId = ?";
        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, hotelId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("HotelAgentId");
                }
                throw new SQLException("HotelAgentId not found for HotelId: " + hotelId);
            }
        }
    }

    public Map<Integer, Double> getEarningsByHotelAgentId(int hotelAgentId) throws SQLException, Exception {
        int currentYear = Year.now().getValue();
        int yearMinus1 = currentYear - 1;
        int yearMinus2 = currentYear - 2;

        String query = "SELECT YEAR(b.CreatedAt) AS earningYear, SUM(b.TotalAmount) AS totalRevenueVND "
                + "FROM Bookings b "
                + "JOIN Rooms r ON b.RoomId = r.RoomId "
                + "JOIN Hotels h ON r.HotelId = h.HotelId "
                + "WHERE h.HotelAgentId = ? "
                + "AND b.BookingStatus = 'Completed' "
                + "AND YEAR(b.CreatedAt) IN (?, ?, ?) "
                + "GROUP BY YEAR(b.CreatedAt)";

        Map<Integer, Double> earningsByYear = new HashMap<>();

        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, hotelAgentId);
            stmt.setInt(2, yearMinus2);
            stmt.setInt(3, yearMinus1);
            stmt.setInt(4, currentYear);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int year = rs.getInt("earningYear");
                    double revenueVND = rs.getDouble("totalRevenueVND");
                    double revenueUSD = revenueVND / EXCHANGE_RATE_VND_TO_USD;
                    earningsByYear.put(year, revenueUSD);
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, "Error calculating earnings for hotelAgentId: " + hotelAgentId, e);
            throw e;
        }

        earningsByYear.putIfAbsent(yearMinus2, 0.0);
        earningsByYear.putIfAbsent(yearMinus1, 0.0);
        earningsByYear.putIfAbsent(currentYear, 0.0);

        Logger.getLogger(BookingDAO.class.getName()).log(Level.INFO, "Earnings for hotelAgentId " + hotelAgentId + ": " + earningsByYear);
        return earningsByYear;
    }

    public boolean checkUserBooking(int userId, int hotelId) throws Exception {
        boolean hasBooked = false;
        String sql = "EXEC CheckUserBooking ?, ?, ?";

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, hotelId);
            stmt.setNull(3, java.sql.Types.BIT); // SQL Server cần có tham số OUTPUT

            // Execute query và lấy kết quả từ ResultSet
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                hasBooked = rs.getBoolean("BookingStatus");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return hasBooked;
    }

    public boolean checkRoomAvailability(int roomId, String checkInDate, String checkOutDate) throws SQLException, Exception {
        boolean isAvailable = false;

        // Log the input to verify the date format
        System.out.println("Received check-in date: " + checkInDate);
        System.out.println("Received check-out date: " + checkOutDate);

        // Define the expected date format
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        // Parse the input date strings to ensure they are in the correct format
        try {
            dateFormat.setLenient(false); // Prevent lenient parsing (e.g., 2025-02-30 would be invalid)

            // Validate and parse the date strings
            dateFormat.parse(checkInDate);  // Will throw an exception if the format is incorrect
            dateFormat.parse(checkOutDate); // Will throw an exception if the format is incorrect
        } catch (ParseException e) {
            throw new IllegalArgumentException("Invalid date format. Please use 'yyyy-MM-dd HH:mm:ss'.");
        }

        String sql = "{CALL CheckRoomAvailability(?, ?, ?, ?)}"; // Call the stored procedure

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); CallableStatement stmt = conn.prepareCall(sql)) {
            // Set parameters for the stored procedure
            stmt.setInt(1, roomId);
            stmt.setTimestamp(2, Timestamp.valueOf(checkInDate));  // Convert String to Timestamp
            stmt.setTimestamp(3, Timestamp.valueOf(checkOutDate)); // Convert String to Timestamp

            // Register the output parameter
            stmt.registerOutParameter(4, java.sql.Types.BIT);

            // Execute the stored procedure
            stmt.execute();

            // Get the result from the output parameter
            isAvailable = stmt.getBoolean(4);
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }

        System.out.println("Room availability: " + isAvailable);
        return isAvailable;
    }

    public boolean bookRoom(int userId, int hotelId, int roomId, Timestamp checkInDate, Timestamp checkOutDate,
            int quantity, double totalServiceAmount, String bookingStatus, String paymentStatus) throws SQLException, Exception {
        boolean isBooked = false;
        String sql = "EXEC BookRoom ?, ?, ?, ?, ?, ?, ?, ?, ?"; // Stored Procedure BookRoom

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Set parameters for stored procedure
            stmt.setInt(1, userId);
            stmt.setInt(2, hotelId);
            stmt.setInt(3, roomId);
            stmt.setTimestamp(4, checkInDate); // Use Timestamp for datetime fields
            stmt.setTimestamp(5, checkOutDate); // Use Timestamp for datetime fields
            stmt.setInt(6, quantity);
            stmt.setDouble(7, totalServiceAmount);
            stmt.setString(8, bookingStatus);
            stmt.setString(9, paymentStatus);

            // Execute stored procedure
            stmt.executeUpdate(); // No need for ResultSet, just execute the update

            // If stored procedure executes successfully, return true
            isBooked = true;
        } catch (SQLException e) {
            e.printStackTrace();
            throw e; // Rethrow exception if any error occurs
        }

        return isBooked;
    }

    public List<Booking> getUserBookings(int userId) throws SQLException, Exception {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.BookingId, h.HotelName, rt.RoomTypeName, b.CheckInDate, b.CheckOutDate, "
                + "b.PricePerNight, b.Quantity, b.TotalAmount, b.BookingStatus "
                + "FROM Bookings b "
                + "JOIN Rooms r ON b.RoomId = r.RoomId "
                + "JOIN Hotels h ON r.HotelId = h.HotelId "
                + "JOIN RoomTypes rt ON r.RoomTypeId = rt.RoomTypeId "
                + "JOIN BookingTransactions bt ON b.TransactionId = bt.TransactionId " // Thêm JOIN với bảng BookingTransactions
                + "WHERE bt.UserId = ?";  // Thay thế b.UserId thành bt.UserId (từ bảng BookingTransactions)

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);  // Thêm UserId từ bảng BookingTransactions
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getInt("BookingId"));
                booking.setHotelName(rs.getString("HotelName"));
                booking.setRoomType(rs.getString("RoomTypeName"));
                booking.setCheckInDate(rs.getTimestamp("CheckInDate"));
                booking.setCheckOutDate(rs.getTimestamp("CheckOutDate"));
                booking.setPricePerNight(rs.getDouble("PricePerNight"));
                booking.setQuantity(rs.getInt("Quantity"));
                booking.setTotalAmount(rs.getDouble("TotalAmount"));
                booking.setBookingStatus(rs.getString("BookingStatus"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Error retrieving bookings", e);
        }

        return bookings;
    }

    public int getBookingCountByHotelAgentId(int hotelAgentId) throws SQLException, Exception {
        String query = "SELECT COUNT(b.bookingId) as bookingCount "
                + "FROM Bookings b "
                + "JOIN Rooms r ON b.roomId = r.roomId "
                + "JOIN Hotels h ON r.hotelId = h.hotelId "
                + "WHERE h.hotelAgentId = ?";

        int bookingCount = 0;

        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, hotelAgentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    bookingCount = rs.getInt("bookingCount");
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, "Error getting booking count by hotel agent id: " + hotelAgentId, e);
            throw e;
        }

        Logger.getLogger(BookingDAO.class.getName()).log(Level.INFO, "Booking count for hotelAgentId " + hotelAgentId + ": " + bookingCount);
        return bookingCount;
    }

    public double getTotalRevenueByHotelAgentId(int hotelAgentId) throws SQLException, Exception {
        String query = "SELECT SUM(b.TotalAmount) AS totalRevenue "
                + "FROM Bookings b "
                + "JOIN Rooms r ON b.RoomId = r.RoomId "
                + "JOIN Hotels h ON r.HotelId = h.HotelId "
                + "WHERE h.HotelAgentId = ? "
                + "AND b.BookingStatus = 'Completed'";

        double totalRevenue = 0.0;

        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, hotelAgentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    totalRevenue = rs.getDouble("totalRevenue");
                    if (rs.wasNull()) {
                        totalRevenue = 0.0; // Xử lý trường hợp SUM trả về NULL
                    }
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, "Error calculating total revenue for hotelAgentId: " + hotelAgentId, e);
            throw e;
        }

        Logger.getLogger(BookingDAO.class.getName()).log(Level.INFO, "Total revenue for hotelAgentId " + hotelAgentId + ": " + totalRevenue);
        return totalRevenue;
    }

    public List<Booking> getLatestTransactionsByAgentId(int hotelAgentId) throws SQLException, Exception {
        String query = "SELECT TOP 4 b.BookingId, b.CreatedAt, b.TotalAmount, h.HotelName "
                + "FROM Bookings b "
                + "JOIN Rooms r ON b.RoomId = r.RoomId "
                + "JOIN Hotels h ON r.HotelId = h.HotelId "
                + "WHERE h.HotelAgentId = ? "
                + "AND b.BookingStatus = 'Completed' "
                + "ORDER BY b.CreatedAt DESC";

        List<Booking> transactions = new ArrayList<>();

        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, hotelAgentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Booking booking = new Booking();
                    booking.setBookingId(rs.getInt("BookingId"));
                    booking.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    double totalAmountVND = rs.getDouble("TotalAmount");
                    booking.setTotalAmount(totalAmountVND / EXCHANGE_RATE_VND_TO_USD); // Chuyển sang USD
                    booking.setHotelName(rs.getString("HotelName"));
                    transactions.add(booking);
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, "Error fetching latest transactions for hotelAgentId: " + hotelAgentId, e);
            throw e;
        }

        Logger.getLogger(BookingDAO.class.getName()).log(Level.INFO, "Latest transactions for hotelAgentId " + hotelAgentId + ": " + transactions.size());
        return transactions;
    }

    public List<Booking> getAllBookings() throws SQLException, Exception {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.BookingId, bt.UserId, r.HotelId, b.RoomId, b.CheckInDate, b.CheckOutDate, "
                + "b.TotalAmount, b.BookingStatus, b.CreatedAt "
                + "FROM Bookings b "
                + "JOIN Rooms r ON b.RoomId = r.RoomId "
                + "JOIN BookingTransactions bt ON b.TransactionId = bt.TransactionId";

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getInt("BookingId"));
                booking.setUserId(rs.getInt("UserId"));
                booking.setHotelId(rs.getInt("HotelId"));
                booking.setRoomId(rs.getInt("RoomId"));
                booking.setCheckInDate(rs.getTimestamp("CheckInDate"));
                booking.setCheckOutDate(rs.getTimestamp("CheckOutDate"));
                double totalAmountVND = rs.getDouble("TotalAmount");
                booking.setTotalAmount(totalAmountVND / EXCHANGE_RATE_VND_TO_USD); // Convert to USD
                booking.setBookingStatus(rs.getString("BookingStatus"));
                booking.setCreatedAt(rs.getTimestamp("CreatedAt"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, "Error retrieving all bookings", e);
            throw new SQLException("Error retrieving all bookings", e);
        }

        Logger.getLogger(BookingDAO.class.getName()).log(Level.INFO, "Retrieved " + bookings.size() + " bookings");
        return bookings;
    }
}
