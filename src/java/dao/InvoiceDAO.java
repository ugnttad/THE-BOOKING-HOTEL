package dao;

import model.Invoice;
import model.Booking;
import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDAO {

    public Invoice getInvoiceDetails(int transactionId) throws SQLException, Exception {
        Invoice invoice = new Invoice();
        List<Booking> bookings = new ArrayList<>();
        double totalAmount = 0;

        // Lấy thông tin Transaction
        String sql = "SELECT bt.TransactionId, bt.TotalAmount, h.HotelAgentId " +
                     "FROM BookingTransactions bt " +
                     "JOIN Hotels h ON bt.UserId = h.HotelAgentId " +
                     "WHERE bt.TransactionId = ?";

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, transactionId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    invoice.setTransactionId(rs.getInt("TransactionId"));
                    invoice.setTotalAmount(rs.getDouble("TotalAmount"));

                    // Lấy Hotel Agent
                    int hotelAgentId = rs.getInt("HotelAgentId");
                    User hotelAgent = UserDAO.getUserByUserId(hotelAgentId);  // Lấy thông tin Hotel Agent
                    invoice.setHotelAgent(hotelAgent);
                }
            }

            // Lấy tất cả các bookings của transaction
            sql = "SELECT b.BookingId, h.HotelName, r.RoomNumber, rt.RoomTypeName, b.CheckInDate, b.CheckOutDate, " +
                  "b.PricePerNight, b.Quantity, b.TotalAmount, b.BookingStatus " +
                  "FROM Bookings b " +
                  "JOIN Rooms r ON b.RoomId = r.RoomId " +
                  "JOIN Hotels h ON r.HotelId = h.HotelId " +
                  "JOIN RoomTypes rt ON r.RoomTypeId = rt.RoomTypeId " +
                  "WHERE b.TransactionId = ?";

            try (PreparedStatement stmtBookings = conn.prepareStatement(sql)) {
                stmtBookings.setInt(1, transactionId);
                try (ResultSet rsBookings = stmtBookings.executeQuery()) {
                    while (rsBookings.next()) {
                        Booking booking = new Booking();
                        booking.setBookingId(rsBookings.getInt("BookingId"));
                        booking.setHotelName(rsBookings.getString("HotelName"));
                        booking.setRoomNumber(rsBookings.getString("RoomNumber"));
                        booking.setRoomType(rsBookings.getString("RoomTypeName"));
                        booking.setCheckInDate(rsBookings.getTimestamp("CheckInDate"));
                        booking.setCheckOutDate(rsBookings.getTimestamp("CheckOutDate"));
                        booking.setPricePerNight(rsBookings.getDouble("PricePerNight"));
                        booking.setQuantity(rsBookings.getInt("Quantity"));
                        booking.setTotalAmount(rsBookings.getDouble("TotalAmount"));
                        booking.setBookingStatus(rsBookings.getString("BookingStatus"));

                        // Cộng dồn tổng tiền của tất cả bookings trong transaction
                        totalAmount += booking.getTotalAmount();

                        bookings.add(booking);
                    }
                }
            }

            // Set the bookings list and totalAmount to the invoice object
            invoice.setBookings(bookings);
            invoice.setTotalAmount(totalAmount);

        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Error retrieving invoice details", e);
        }

        return invoice;
    }
}