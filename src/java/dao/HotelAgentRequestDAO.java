package dao;

import model.HotelAgentRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import org.json.JSONArray;
import java.sql.ResultSet;

public class HotelAgentRequestDAO {

    public boolean addHotelAgentRequest(HotelAgentRequest request) throws SQLException, Exception {
        String sql = "INSERT INTO HotelAgentRequests (UserId, HotelName, BusinessLicense, Address, Description, RequestStatus, RequestType, SubmittedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";

        Connection connection = null;
        PreparedStatement ps = null;

        try {
            connection = JDBC.getConnectionWithSqlJdbc();
            connection.setAutoCommit(false); // Bắt đầu transaction

            // Chuyển businessLicenseUrls thành chuỗi JSON
            String businessLicenseJson = (request.getBusinessLicenseUrls() != null && !request.getBusinessLicenseUrls().isEmpty())
                    ? new JSONArray(request.getBusinessLicenseUrls()).toString()
                    : null;

            // Thêm yêu cầu vào bảng HotelAgentRequests
            ps = connection.prepareStatement(sql);
            ps.setInt(1, request.getUserId());
            ps.setString(2, request.getHotelName());
            ps.setString(3, businessLicenseJson); // Lưu BusinessLicense dưới dạng JSON
            ps.setString(4, request.getAddress());
            ps.setString(5, request.getDescription());
            ps.setString(6, request.getRequestStatus());
            ps.setString(7, request.getRequestType());

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0) {
                connection.rollback();
                return false;
            }

            connection.commit(); // Commit transaction
            return true;

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
            if (ps != null) {
                ps.close();
            }
            if (connection != null) {
                connection.close();
            }
        }
    }

    public HotelAgentRequest getPendingRequestByUserId(int userId) throws Exception {
        String sql = "SELECT * FROM HotelAgentRequests WHERE UserId = ? AND RequestStatus = 'Pending'";
        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                HotelAgentRequest request = new HotelAgentRequest();
                request.setRequestId(rs.getInt("RequestId"));
                request.setUserId(rs.getInt("UserId"));
                request.setHotelName(rs.getString("HotelName"));
                request.setBusinessLicenseUrlsString(rs.getString("BusinessLicense"));
                request.setAddress(rs.getString("Address"));
                request.setDescription(rs.getString("Description"));
                request.setRequestStatus(rs.getString("RequestStatus"));
                request.setRequestType(rs.getString("RequestType"));
                request.setSubmittedAt(rs.getTimestamp("SubmittedAt"));
                return request;
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public HotelAgentRequest getRequestByUserId(int userId) throws Exception {
        String sql = "SELECT TOP 1 * FROM HotelAgentRequests WHERE UserId = ? ORDER BY SubmittedAt DESC";
        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                HotelAgentRequest request = new HotelAgentRequest();
                request.setRequestId(rs.getInt("RequestId"));
                request.setUserId(rs.getInt("UserId"));
                request.setHotelName(rs.getString("HotelName"));
                request.setBusinessLicenseUrlsString(rs.getString("BusinessLicense"));
                request.setAddress(rs.getString("Address"));
                request.setDescription(rs.getString("Description"));
                request.setRequestStatus(rs.getString("RequestStatus"));
                request.setSubmittedAt(rs.getTimestamp("SubmittedAt"));
                request.setRejectionReason(rs.getString("RejectionReason"));
                return request;
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public HotelAgentRequest getRequestById(int requestId) throws Exception {
        String sql = "SELECT * FROM HotelAgentRequests WHERE RequestId = ?";
        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, requestId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                HotelAgentRequest request = new HotelAgentRequest();
                request.setRequestId(rs.getInt("RequestId"));
                request.setUserId(rs.getInt("UserId"));
                request.setHotelName(rs.getString("HotelName"));
                request.setBusinessLicenseUrlsString(rs.getString("BusinessLicense"));
                request.setAddress(rs.getString("Address"));
                request.setDescription(rs.getString("Description"));
                request.setRequestStatus(rs.getString("RequestStatus"));
                request.setRequestType(rs.getString("RequestType"));
                request.setSubmittedAt(rs.getTimestamp("SubmittedAt"));
                return request;
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean approveRequest(int requestId, int adminId) throws Exception {
        String selectRequestSql = "SELECT RequestType, UserId FROM HotelAgentRequests WHERE RequestId = ?";
        String updateRequestSql = "UPDATE HotelAgentRequests SET RequestStatus = 'Approved', ReviewedAt = GETDATE(), ReviewedBy = ? WHERE RequestId = ?";
        String updateUserRoleSql = "UPDATE Users SET RoleId = 3 WHERE UserId = ?";
        String insertHotelSql = "INSERT INTO Hotels (HotelName, Location, Description, HotelAgentId, CreatedAt, IsAccepted) "
                + "SELECT HotelName, Address, Description, UserId, GETDATE(), 1 "
                + "FROM HotelAgentRequests WHERE RequestId = ?";

        Connection conn = null;
        try {
            conn = JDBC.getConnectionWithSqlJdbc(); // Giả định JDBC là class cung cấp connection
            conn.setAutoCommit(false); // Bắt đầu transaction

            // 1. Lấy thông tin RequestType và UserId từ request
            String requestType = null;
            int userId = -1;
            try (PreparedStatement pstmtSelect = conn.prepareStatement(selectRequestSql)) {
                pstmtSelect.setInt(1, requestId);
                ResultSet rs = pstmtSelect.executeQuery();
                if (rs.next()) {
                    requestType = rs.getString("RequestType");
                    userId = rs.getInt("UserId");
                } else {
                    throw new SQLException("No request found with RequestId = " + requestId);
                }
            }

            // 2. Cập nhật trạng thái request
            try (PreparedStatement pstmtRequest = conn.prepareStatement(updateRequestSql)) {
                pstmtRequest.setInt(1, adminId);
                pstmtRequest.setInt(2, requestId);
                int rowsAffectedRequest = pstmtRequest.executeUpdate();
                if (rowsAffectedRequest == 0) {
                    throw new SQLException("Failed to update request with RequestId = " + requestId);
                }
            }

            // 3. Xử lý theo RequestType
            if ("BecomeHotelAgent".equals(requestType)) {
                // Cập nhật RoleId của User thành 3 (Hotel Agent)
                try (PreparedStatement pstmtUser = conn.prepareStatement(updateUserRoleSql)) {
                    pstmtUser.setInt(1, userId);
                    int rowsAffectedUser = pstmtUser.executeUpdate();
                    if (rowsAffectedUser == 0) {
                        throw new SQLException("No user found for UserId = " + userId);
                    }
                }
            }

            // 4. Thêm dữ liệu khách sạn vào bảng Hotels (áp dụng cho cả BecomeHotelAgent và AddHotel)
            try (PreparedStatement pstmtHotel = conn.prepareStatement(insertHotelSql)) {
                pstmtHotel.setInt(1, requestId);
                int rowsAffectedHotel = pstmtHotel.executeUpdate();
                if (rowsAffectedHotel == 0) {
                    throw new SQLException("Failed to insert hotel for RequestId = " + requestId);
                }
            }

            conn.commit(); // Commit transaction nếu tất cả bước thành công
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback nếu có lỗi
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Khôi phục chế độ auto-commit
                    conn.close(); // Đóng connection
                } catch (SQLException closeEx) {
                    closeEx.printStackTrace();
                }
            }
        }
    }

    public boolean rejectRequest(int requestId, int adminId, String rejectionReason) throws Exception {
        String sql = "UPDATE HotelAgentRequests SET RequestStatus = 'Rejected', ReviewedAt = GETDATE(), ReviewedBy = ?, RejectionReason = ? WHERE RequestId = ?";
        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, adminId);
            pstmt.setString(2, rejectionReason);
            pstmt.setInt(3, requestId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
