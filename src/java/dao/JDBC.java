package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class JDBC {

    public static Connection getConnectionWithSqlJdbc() throws Exception {
        Connection con = null;
        String dbUser = "sa";
        String dbPassword = "123";
        String port = "1433";
        String IP = "169.254.157.38";
        String ServerName = "LAPTOP-UM0RI4KU";
        String DBName = "hotel_bookingv3103";
        String driverClass = "com.microsoft.sqlserver.jdbc.SQLServerDriver";

        String dbURL = "jdbc:sqlserver://" + ServerName + ";databaseName=" + DBName + ";encrypt=false;trustServerCertificate=false;loginTimeout=30";
        try {
            Class.forName(driverClass);
            con = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        } catch (SQLException e) {
            System.out.println("Error: " + e);
        }
        return con;
    }

    public static void main(String[] args) {
        try {
            Connection con = getConnectionWithSqlJdbc();
            if (con != null && !con.isClosed()) {
                System.out.println("Connection successful!");
                con.close();
            } else {
                System.out.println("Failed to connect.");
            }
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
