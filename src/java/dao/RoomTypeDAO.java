package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.RoomType;

public class RoomTypeDAO {

    public List<RoomType> getTop5BookedRoomTypes() throws Exception {
        List<RoomType> roomTypes = new ArrayList<>();
        String sql = "EXEC GetTop5BookedRoomTypes";
        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                RoomType roomType = new RoomType();
                roomType.setRoomTypeId(rs.getInt("RoomTypeId"));
                roomType.setRoomTypeName(rs.getString("RoomTypeName"));
                roomTypes.add(roomType);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (roomTypes.isEmpty()) {
            roomTypes.add(new RoomType(1, "Standard Room"));
            roomTypes.add(new RoomType(2, "Deluxe Room"));
            roomTypes.add(new RoomType(3, "Suite"));
            roomTypes.add(new RoomType(4, "Family Room"));
            roomTypes.add(new RoomType(5, "Executive Room"));
        }

        return roomTypes;
    }

    public List<RoomType> getAllRoomTypes() throws Exception {
        List<RoomType> roomTypes = new ArrayList<>();
        String sql = "SELECT * FROM RoomTypes"; // Lấy tất cả các loại phòng từ bảng RoomTypes
        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                RoomType roomType = new RoomType();
                roomType.setRoomTypeId(rs.getInt("RoomTypeId"));
                roomType.setRoomTypeName(rs.getString("RoomTypeName"));
                roomTypes.add(roomType);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return roomTypes;
    }
}
