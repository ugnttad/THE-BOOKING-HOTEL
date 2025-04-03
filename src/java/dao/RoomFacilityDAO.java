package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.RoomFacility;
import java.sql.SQLException;

public class RoomFacilityDAO {

    public List<RoomFacility> getTop5RoomFacilities() throws Exception {
        List<RoomFacility> facilities = new ArrayList<>();
        String sql = "EXEC GetTop5RoomFacilities";

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                RoomFacility facility = new RoomFacility();
                facility.setFacilityId(rs.getInt("FacilityId"));
                facility.setFacilityName(rs.getString("FacilityName"));
                facilities.add(facility);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (facilities.isEmpty()) {
            for (int i = 1; i <= 5; i++) {
                RoomFacility defaultFacility = new RoomFacility();
                defaultFacility.setFacilityId(i);
                defaultFacility.setFacilityName("Default Facility " + i);
                facilities.add(defaultFacility);
            }
        }

        return facilities;
    }

    public List<RoomFacility> getRoomFacilitiesByRoomId(int roomId) throws SQLException, Exception {
        String query = "SELECT rf.facilityId, rf.facilityName "
                + "FROM RoomFacilities rf "
                + "JOIN Room_RoomFacility rrf ON rf.facilityId = rrf.facilityId "
                + "WHERE rrf.roomId = ?";

        List<RoomFacility> roomFacilities = new ArrayList<>();

        try (Connection connection = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = connection.prepareStatement(query)) {

            stmt.setInt(1, roomId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int facilityId = rs.getInt("facilityId");
                    String facilityName = rs.getString("facilityName");

                    RoomFacility roomFacility = new RoomFacility(facilityId, facilityName);
                    roomFacilities.add(roomFacility);
                }
            }
        }

        return roomFacilities;
    }

    public List<RoomFacility> getAllRoomFacilities() throws Exception {
        List<RoomFacility> facilities = new ArrayList<>();
        String sql = "SELECT facilityId, facilityName FROM RoomFacilities";

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                RoomFacility facility = new RoomFacility();
                facility.setFacilityId(rs.getInt("facilityId"));
                facility.setFacilityName(rs.getString("facilityName"));
                facilities.add(facility);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }

        return facilities;
    }
}
