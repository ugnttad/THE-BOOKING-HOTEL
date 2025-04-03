package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.HotelService;

public class HotelServiceDAO {

    public List<HotelService> getAllFreeServices() throws Exception {
        List<HotelService> services = new ArrayList<>();
        String sql = "SELECT * FROM HotelServices WHERE HotelServiceEstimatedPrice = 0";

        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                int serviceId = rs.getInt("ServiceId");
                String serviceName = rs.getString("ServiceName");
                double hotelServiceEstimatedPrice = rs.getDouble("HotelServiceEstimatedPrice");
                String hotelServiceDescription = rs.getString("HotelServiceDescription");

                HotelService service = new HotelService(serviceId, serviceName, hotelServiceEstimatedPrice, hotelServiceDescription);
                services.add(service);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new Exception("Error fetching free services", e);
        }

        return services;
    }
}