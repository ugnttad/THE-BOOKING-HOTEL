package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import model.Room;
import model.RoomFacility;
import org.json.JSONArray;

public class RoomDAO {

    public List<Room> getRoomsByHotelId(int hotelId) throws SQLException, Exception {
        String query = "SELECT r.roomId, r.hotelId, r.roomNumber, r.roomDescription, r.roomTypeId, r.roomImageURLs, "
                + "r.pricePerNight, r.capacity, r.isAvailable, rt.roomTypeName "
                + "FROM Rooms r "
                + "JOIN RoomTypes rt ON r.roomTypeId = rt.roomTypeId "
                + "WHERE r.hotelId = ?";

        List<Room> rooms = new ArrayList<>();

        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = connection.prepareStatement(query)) {

            stmt.setInt(1, hotelId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int roomId = rs.getInt("roomId");
                    String roomNumber = rs.getString("roomNumber");
                    String roomDescription = rs.getString("roomDescription");
                    int roomTypeId = rs.getInt("roomTypeId");
                    double pricePerNight = rs.getDouble("pricePerNight");
                    int capacity = rs.getInt("capacity");
                    boolean isAvailable = rs.getBoolean("isAvailable");
                    String roomTypeName = rs.getString("roomTypeName");

                    Room room = new Room(roomId, hotelId, roomNumber, roomDescription,
                            roomTypeId, roomTypeName, pricePerNight, capacity, isAvailable);
                    room.setRoomImageURLs(rs.getString("roomImageURLs"));
                    rooms.add(room);
                }
            }
        }

        Collections.sort(rooms, (Room r1, Room r2) -> Boolean.compare(r2.isAvailable(), r1.isAvailable())
        );

        return rooms;
    }

    public Room getRoomById(int roomId) throws SQLException, Exception {
        String query = "SELECT r.roomId, r.hotelId, r.roomNumber, r.roomDescription, r.roomTypeId, "
                + "r.pricePerNight, r.capacity, r.isAvailable, r.roomImageURLs, rt.roomTypeName "
                + "FROM Rooms r "
                + "JOIN RoomTypes rt ON r.roomTypeId = rt.roomTypeId "
                + "WHERE r.roomId = ?";

        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, roomId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Room room = new Room(
                            rs.getInt("roomId"),
                            rs.getInt("hotelId"),
                            rs.getString("roomNumber"),
                            rs.getString("roomDescription"),
                            rs.getInt("roomTypeId"),
                            rs.getString("roomTypeName"),
                            rs.getDouble("pricePerNight"),
                            rs.getInt("capacity"),
                            rs.getBoolean("isAvailable")
                    );
                    room.setRoomImageURLs(rs.getString("roomImageURLs"));
                    return room;
                }
            }
        }
        return null;
    }

    public void updateRoomStatusToAvailable() throws SQLException, Exception {
        String currentDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date()); // Lấy ngày hiện tại theo định dạng yyyy-MM-dd
        String query = "SELECT r.roomId, b.checkOutDate "
                + "FROM Bookings b "
                + "JOIN Rooms r ON b.roomId = r.roomId "
                + "WHERE CONVERT(DATE, b.checkOutDate) = ? AND r.isAvailable = 0"; // Kiểm tra ngày checkout và trạng thái phòng không phải Available

        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = connection.prepareStatement(query)) {

            stmt.setString(1, currentDate);

            try (ResultSet rs = stmt.executeQuery()) {
                // Nếu có phòng cần cập nhật, thực hiện cập nhật trạng thái
                while (rs.next()) {
                    int roomId = rs.getInt("roomId");

                    // Debug: In thông tin phòng trước khi cập nhật
                    System.out.println("Updating room with ID: " + roomId + " to Available.");

                    // Cập nhật trạng thái phòng thành Available
                    updateRoomStatus(roomId);

                    // Debug: Thông báo sau khi cập nhật phòng
                    System.out.println("Room with ID: " + roomId + " has been updated to Available.");
                }
            }
        }
    }

    // Hàm cập nhật trạng thái phòng thành Available
    private void updateRoomStatus(int roomId) throws SQLException, Exception {
        String updateQuery = "UPDATE Rooms SET isAvailable = 1 WHERE roomId = ?";

        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = connection.prepareStatement(updateQuery)) {

            stmt.setInt(1, roomId);
            stmt.executeUpdate();
        }
    }

    public int addRoom(int hotelId, String roomNumber, String roomDescription, int roomTypeId,
            double pricePerNight, int capacity, List<String> facilityIds, List<String> imageUrls)
            throws SQLException, Exception {
        String insertRoomSql = "INSERT INTO Rooms (HotelId, RoomNumber, RoomDescription, RoomTypeId, PricePerNight, Capacity, IsAvailable, RoomImageURLs) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        String insertFacilitySql = "INSERT INTO Room_RoomFacility (RoomId, FacilityId) VALUES (?, ?)";

        Connection connection = null;
        PreparedStatement psRoom = null;
        PreparedStatement psFacility = null;
        ResultSet rs = null;

        try {
            connection = JDBC.getConnectionWithSqlJdbc();
            connection.setAutoCommit(false); // Bắt đầu transaction

            // Chuyển imageUrls thành chuỗi JSON
            String imageUrlsJson = (imageUrls != null && !imageUrls.isEmpty()) ? new JSONArray(imageUrls).toString() : null;

            // Thêm phòng vào bảng Rooms
            psRoom = connection.prepareStatement(insertRoomSql, PreparedStatement.RETURN_GENERATED_KEYS);
            psRoom.setInt(1, hotelId);
            psRoom.setString(2, roomNumber);
            psRoom.setString(3, roomDescription);
            psRoom.setInt(4, roomTypeId);
            psRoom.setDouble(5, pricePerNight);
            psRoom.setInt(6, capacity);
            psRoom.setBoolean(7, true); // IsAvailable mặc định là true
            psRoom.setString(8, imageUrlsJson); // Lưu RoomImageURLs
            int rowsAffected = psRoom.executeUpdate();

            if (rowsAffected == 0) {
                connection.rollback();
                return -1;
            }

            // Lấy roomId vừa thêm
            rs = psRoom.getGeneratedKeys();
            int roomId = -1;
            if (rs.next()) {
                roomId = rs.getInt(1);
            } else {
                connection.rollback();
                return -1;
            }

            // Thêm các tiện ích vào bảng Room_RoomFacility (nếu có)
            if (facilityIds != null && !facilityIds.isEmpty()) {
                psFacility = connection.prepareStatement(insertFacilitySql);
                for (String facilityId : facilityIds) {
                    psFacility.setInt(1, roomId);
                    psFacility.setInt(2, Integer.parseInt(facilityId));
                    psFacility.addBatch();
                }
                psFacility.executeBatch();
            }

            connection.commit(); // Commit transaction
            return roomId;

        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback(); // Rollback nếu có lỗi
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            throw e; // Ném ngoại lệ để xử lý ở tầng trên
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (psRoom != null) {
                psRoom.close();
            }
            if (psFacility != null) {
                psFacility.close();
            }
            if (connection != null) {
                connection.close();
            }
        }
    }

    public List<Integer> getRoomFacilityIds(int roomId) throws SQLException, Exception {
        String query = "SELECT FacilityId FROM Room_RoomFacility WHERE RoomId = ?";
        List<Integer> facilityIds = new ArrayList<>();

        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, roomId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    facilityIds.add(rs.getInt("FacilityId"));
                }
            }
        }
        return facilityIds;
    }

    // Lấy tất cả room facilities
    public List<RoomFacility> getAllRoomFacilities() throws SQLException, Exception {
        String query = "SELECT FacilityId, FacilityName FROM RoomFacilities"; // Giả định bảng RoomFacilities
        List<RoomFacility> facilities = new ArrayList<>();

        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = connection.prepareStatement(query)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    RoomFacility facility = new RoomFacility(
                            rs.getInt("FacilityId"),
                            rs.getString("FacilityName")
                    );
                    facilities.add(facility);
                }
            }
        }
        return facilities;
    }

    // Cập nhật room
    public boolean updateRoom(int roomId, int hotelId, String roomNumber, String roomDescription, int roomTypeId,
            double pricePerNight, int capacity, List<String> facilityIds, List<String> imageUrls)
            throws SQLException, Exception {
        String updateRoomSql = "UPDATE Rooms SET RoomNumber = ?, RoomDescription = ?, RoomTypeId = ?, "
                + "PricePerNight = ?, Capacity = ?, RoomImageURLs = ? WHERE RoomId = ? AND HotelId = ?";
        String deleteFacilitiesSql = "DELETE FROM Room_RoomFacility WHERE RoomId = ?";
        String insertFacilitySql = "INSERT INTO Room_RoomFacility (RoomId, FacilityId) VALUES (?, ?)";

        Connection connection = null;
        PreparedStatement psUpdate = null;
        PreparedStatement psDelete = null;
        PreparedStatement psInsert = null;

        try {
            connection = JDBC.getConnectionWithSqlJdbc();
            connection.setAutoCommit(false);

            // Cập nhật thông tin room
            psUpdate = connection.prepareStatement(updateRoomSql);
            psUpdate.setString(1, roomNumber);
            psUpdate.setString(2, roomDescription);
            psUpdate.setInt(3, roomTypeId);
            psUpdate.setDouble(4, pricePerNight);
            psUpdate.setInt(5, capacity);
            psUpdate.setString(6, new JSONArray(imageUrls).toString());
            psUpdate.setInt(7, roomId);
            psUpdate.setInt(8, hotelId);
            int rowsAffected = psUpdate.executeUpdate();

            if (rowsAffected == 0) {
                connection.rollback();
                return false;
            }

            // Xóa facilities cũ
            psDelete = connection.prepareStatement(deleteFacilitiesSql);
            psDelete.setInt(1, roomId);
            psDelete.executeUpdate();

            // Thêm facilities mới
            if (!facilityIds.isEmpty()) {
                psInsert = connection.prepareStatement(insertFacilitySql);
                for (String facilityId : facilityIds) {
                    psInsert.setInt(1, roomId);
                    psInsert.setInt(2, Integer.parseInt(facilityId));
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
}
