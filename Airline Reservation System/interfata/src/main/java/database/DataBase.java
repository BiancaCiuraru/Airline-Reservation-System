package database;

import java.sql.*;
public class DataBase {

    public static Connection createConnection() {
        Connection connection = null;
        try {
            Class.forName( "oracle.jdbc.driver.OracleDriver" );
            connection = DriverManager.getConnection( "jdbc:oracle:thin:@localhost:1521:xe", "aeroport", "AEROPORT" );
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

//        Statement statement=((Connection) connection).createStatement();
//        String sql="select nume from pasageri";
//        ResultSet rs=((Statement) statement).executeQuery(sql);
//
//        while((rs).next())
//            System.out.println(rs.getString(1));
//
//        rs.close();
        return connection;
    }
}
