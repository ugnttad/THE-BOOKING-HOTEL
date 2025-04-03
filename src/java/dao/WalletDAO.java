package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.Timestamp; // Import đúng package
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Wallet;
import model.WalletTransaction;

public class WalletDAO {

    private static final double EXCHANGE_RATE_VND_TO_USD = 25336.0;

    public void addToWallet(int ownerId, String ownerType, BigDecimal amountVND, String transactionType, String description, int relatedBookingTransactionId) throws SQLException, Exception {
        Connection con = null;
        PreparedStatement psUpdateWallet = null;
        PreparedStatement psInsertTransaction = null;
        try {
            con = JDBC.getConnectionWithSqlJdbc();
            con.setAutoCommit(false);

            // Cập nhật số dư ví
            String sqlUpdateWallet = "UPDATE Wallets SET Balance = Balance + ?, LastUpdatedAt = GETDATE() "
                    + "WHERE OwnerId = ? AND OwnerType = ?";
            psUpdateWallet = con.prepareStatement(sqlUpdateWallet);
            psUpdateWallet.setBigDecimal(1, amountVND);
            psUpdateWallet.setInt(2, ownerId);
            psUpdateWallet.setString(3, ownerType);
            int rowsUpdated = psUpdateWallet.executeUpdate();

            if (rowsUpdated > 0) {
                // Ghi giao dịch
                String sqlInsertTransaction = "INSERT INTO WalletTransactions (WalletId, Amount, TransactionType, Description, CreatedAt, RelatedBookingTransactionId) "
                        + "VALUES ((SELECT WalletId FROM Wallets WHERE OwnerId = ? AND OwnerType = ?), ?, ?, ?, GETDATE(), ?)";
                psInsertTransaction = con.prepareStatement(sqlInsertTransaction);
                psInsertTransaction.setInt(1, ownerId);
                psInsertTransaction.setString(2, ownerType);
                psInsertTransaction.setBigDecimal(3, amountVND);
                psInsertTransaction.setString(4, transactionType);
                psInsertTransaction.setString(5, description);
                psInsertTransaction.setInt(6, relatedBookingTransactionId);
                int rowsInserted = psInsertTransaction.executeUpdate();

                if (rowsInserted > 0) {
                    con.commit();
                    Logger.getLogger(WalletDAO.class.getName()).log(Level.INFO,
                            "Added {0} VND to wallet for OwnerId: {1}, OwnerType: {2}, TransactionType: {3}",
                            new Object[]{amountVND, ownerId, ownerType, transactionType});
                } else {
                    throw new SQLException("Failed to insert wallet transaction");
                }
            } else {
                throw new SQLException("Failed to update wallet balance");
            }
        } catch (SQLException e) {
            if (con != null) {
                con.rollback();
            }
            Logger.getLogger(WalletDAO.class.getName()).log(Level.SEVERE,
                    "Error adding to wallet for OwnerId: " + ownerId + ", OwnerType: " + ownerType, e);
            throw e;
        } finally {
            if (psUpdateWallet != null) {
                psUpdateWallet.close();
            }
            if (psInsertTransaction != null) {
                psInsertTransaction.close();
            }
            if (con != null) {
                con.close();
            }
        }
    }

    // Lấy số dư ví của Hotel Agent
    public BigDecimal getWalletBalance(int ownerId, String ownerType) throws SQLException, Exception {
        String sql = "SELECT Balance FROM Wallets WHERE OwnerId = ? AND OwnerType = ?";
        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ps.setString(2, ownerType);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BigDecimal balance = rs.getBigDecimal("Balance");
                    Logger.getLogger(WalletDAO.class.getName()).log(Level.INFO,
                            "Retrieved balance {0} VND for OwnerId: {1}, OwnerType: {2}",
                            new Object[]{balance, ownerId, ownerType});
                    return balance;
                }
                Logger.getLogger(WalletDAO.class.getName()).log(Level.WARNING,
                        "No wallet found for OwnerId: {0}, OwnerType: {1}",
                        new Object[]{ownerId, ownerType});
                return BigDecimal.ZERO;
            }
        }
    }

    public List<WalletTransaction> getWalletTransactions(int ownerId, String ownerType) throws SQLException, Exception {
        List<WalletTransaction> transactions = new ArrayList<>();
        String sql = "SELECT wt.TransactionId, wt.Amount, wt.TransactionType, wt.Description, wt.CreatedAt, wt.RelatedBookingTransactionId "
                + "FROM WalletTransactions wt "
                + "JOIN Wallets w ON wt.WalletId = w.WalletId "
                + "WHERE w.OwnerId = ? AND w.OwnerType = ? "
                + "ORDER BY wt.CreatedAt DESC";
        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ps.setString(2, ownerType);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WalletTransaction transaction = new WalletTransaction(
                            rs.getInt("TransactionId"),
                            rs.getBigDecimal("Amount"),
                            rs.getString("TransactionType"),
                            rs.getString("Description"),
                            rs.getTimestamp("CreatedAt"),
                            rs.getInt("RelatedBookingTransactionId") == 0 ? null : rs.getInt("RelatedBookingTransactionId")
                    );
                    transactions.add(transaction);
                }
                Logger.getLogger(WalletDAO.class.getName()).log(Level.INFO,
                        "Retrieved {0} transactions for OwnerId: {1}, OwnerType: {2}",
                        new Object[]{transactions.size(), ownerId, ownerType});
            }
        }
        return transactions;
    }

    // Xử lý rút tiền
    public boolean withdrawPayment(int ownerId, String ownerType, BigDecimal amountVND) throws SQLException, Exception {
        Connection con = null;
        PreparedStatement psUpdateWallet = null;
        PreparedStatement psInsertTransaction = null;
        try {
            con = JDBC.getConnectionWithSqlJdbc();
            con.setAutoCommit(false); // Bắt đầu transaction

            // Kiểm tra số dư
            BigDecimal currentBalance = getWalletBalance(ownerId, ownerType);
            if (currentBalance.compareTo(amountVND) < 0) {
                Logger.getLogger(WalletDAO.class.getName()).log(Level.WARNING,
                        "Insufficient balance for OwnerId: {0}, OwnerType: {1}. Current: {2}, Requested: {3}",
                        new Object[]{ownerId, ownerType, currentBalance, amountVND});
                return false;
            }

            // Cập nhật số dư ví
            String sqlUpdateWallet = "UPDATE Wallets SET Balance = Balance - ?, LastUpdatedAt = GETDATE() "
                    + "WHERE OwnerId = ? AND OwnerType = ?";
            psUpdateWallet = con.prepareStatement(sqlUpdateWallet);
            psUpdateWallet.setBigDecimal(1, amountVND);
            psUpdateWallet.setInt(2, ownerId);
            psUpdateWallet.setString(3, ownerType);
            int rowsUpdated = psUpdateWallet.executeUpdate();

            if (rowsUpdated > 0) {
                // Ghi lại giao dịch rút tiền
                String sqlInsertTransaction = "INSERT INTO WalletTransactions (WalletId, Amount, TransactionType, Description, CreatedAt, RelatedBookingTransactionId) "
                        + "VALUES ((SELECT WalletId FROM Wallets WHERE OwnerId = ? AND OwnerType = ?), ?, 'Withdrawal', 'Hotel Agent withdrew payment', GETDATE(), NULL)";
                psInsertTransaction = con.prepareStatement(sqlInsertTransaction);
                psInsertTransaction.setInt(1, ownerId);
                psInsertTransaction.setString(2, ownerType);
                psInsertTransaction.setBigDecimal(3, amountVND);
                int rowsInserted = psInsertTransaction.executeUpdate();

                if (rowsInserted > 0) {
                    con.commit();
                    Logger.getLogger(WalletDAO.class.getName()).log(Level.INFO,
                            "Withdrawal of {0} VND successful for OwnerId: {1}, OwnerType: {2}",
                            new Object[]{amountVND, ownerId, ownerType});
                    return true;
                }
            }
            con.rollback();
            return false;
        } catch (SQLException e) {
            if (con != null) {
                con.rollback();
            }
            Logger.getLogger(WalletDAO.class.getName()).log(Level.SEVERE,
                    "Error withdrawing payment for OwnerId: " + ownerId + ", OwnerType: " + ownerType, e);
            throw e;
        } finally {
            if (psUpdateWallet != null) {
                psUpdateWallet.close();
            }
            if (psInsertTransaction != null) {
                psInsertTransaction.close();
            }
            if (con != null) {
                con.close();
            }
        }
    }

    public Wallet createWallet(int ownerId, String ownerType) throws Exception {
        String sql = "INSERT INTO Wallets (OwnerId, OwnerType, Balance) VALUES (?, ?, 0)";
        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, ownerId);
            ps.setString(2, ownerType);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int walletId = rs.getInt(1);
                        // Lấy thời gian hiện tại làm lastUpdatedAt
                        Timestamp lastUpdatedAt = new Timestamp(System.currentTimeMillis());
                        // Tạo đối tượng Wallet với constructor khớp
                        Wallet wallet = new Wallet(walletId, ownerId, ownerType, BigDecimal.ZERO, lastUpdatedAt);
                        Logger.getLogger(WalletDAO.class.getName()).log(Level.INFO,
                                "Wallet created successfully for OwnerId: {0}, OwnerType: {1}, WalletId: {2}",
                                new Object[]{ownerId, ownerType, walletId});
                        return wallet;
                    } else {
                        Logger.getLogger(WalletDAO.class.getName()).log(Level.SEVERE,
                                "Failed to retrieve generated WalletId for OwnerId: {0}, OwnerType: {1}",
                                new Object[]{ownerId, ownerType});
                        return null;
                    }
                }
            }
            Logger.getLogger(WalletDAO.class.getName()).log(Level.WARNING,
                    "Failed to create wallet for OwnerId: {0}, OwnerType: {1}",
                    new Object[]{ownerId, ownerType});
            return null;
        } catch (SQLException e) {
            Logger.getLogger(WalletDAO.class.getName()).log(Level.SEVERE,
                    "Error creating wallet for OwnerId: " + ownerId + ", OwnerType: " + ownerType, e);
            throw e; // Ném lại exception để xử lý ở tầng trên nếu cần
        }
    }

    public boolean walletExists(int ownerId, String ownerType) throws Exception {
        String sql = "SELECT COUNT(*) AS walletCount FROM Wallets WHERE OwnerId = ? AND OwnerType = ?";
        try (Connection conn = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ps.setString(2, ownerType);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt("walletCount");
                    Logger.getLogger(WalletDAO.class.getName()).log(Level.FINE,
                            "Checked wallet existence for OwnerId: {0}, OwnerType: {1}. Exists: {2}",
                            new Object[]{ownerId, ownerType, count > 0});
                    return count > 0;
                }
            }
            Logger.getLogger(WalletDAO.class.getName()).log(Level.WARNING,
                    "No result returned while checking wallet for OwnerId: {0}, OwnerType: {1}",
                    new Object[]{ownerId, ownerType});
            return false;
        } catch (SQLException e) {
            Logger.getLogger(WalletDAO.class.getName()).log(Level.SEVERE,
                    "Error checking wallet existence for OwnerId: " + ownerId + ", OwnerType: " + ownerType, e);
            throw e; // Ném lại exception để xử lý ở tầng trên nếu cần
        }
    }

    public BigDecimal getLastWithdrawnAmount(int ownerId, String ownerType) throws SQLException, Exception {
        String sql = "SELECT TOP 1 Amount "
                + "FROM WalletTransactions wt "
                + "JOIN Wallets w ON wt.WalletId = w.WalletId "
                + "WHERE w.OwnerId = ? AND w.OwnerType = ? AND wt.TransactionType = 'Withdrawal' "
                + "ORDER BY wt.CreatedAt DESC";
        try (Connection con = JDBC.getConnectionWithSqlJdbc(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ps.setString(2, ownerType);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BigDecimal amount = rs.getBigDecimal("Amount");
                    Logger.getLogger(WalletDAO.class.getName()).log(Level.INFO,
                            "Retrieved last withdrawn amount {0} VND for OwnerId: {1}, OwnerType: {2}",
                            new Object[]{amount, ownerId, ownerType});
                    return amount;
                }
                Logger.getLogger(WalletDAO.class.getName()).log(Level.FINE,
                        "No withdrawal transactions found for OwnerId: {0}, OwnerType: {1}",
                        new Object[]{ownerId, ownerType});
                return BigDecimal.ZERO; // Trả về 0 nếu chưa có giao dịch rút tiền
            }
        }
    }
}
