package models;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Connector {
	static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";  
    static final String DB_URL = 
    	"jdbc:mysql://localhost:3306/game?autoReconnect=true&useSSL=false";
	static final String USER = "root";
	static final String PASSWORD = "1228";
	
	public static Connection getConn() {
		Connection conn = null;
		try {
			Class.forName(JDBC_DRIVER); 
			conn = DriverManager.getConnection(DB_URL, USER, PASSWORD);
		} 
		catch(ClassNotFoundException e) {
			System.out.println("DriverClassNotFound: " + e.toString());
		} 
		catch(SQLException x) {
			System.out.println("Exception: " + x.toString());
		}
		return conn;
	}
}
