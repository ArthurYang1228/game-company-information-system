package models;

import java.sql.*;
import java.util.ArrayList;

public class SafeQuantity {
	
private Connection conn;
	
	public SafeQuantity(Connection conn) {
		this.conn = conn;
	}
	
	public void Compute() {
		
		double z = 1.65;//5%­·ÀI
		try {
			
			Statement stmt = conn.createStatement();
			String sql = "SELECT * FROM inventory";
			ResultSet rst=stmt.executeQuery(sql);
			
			int update = 0;
			
			while(rst.next()) {
				int a = rst.getInt("sd");
				int b = rst.getInt("id");
				double safeQuantity = z*a;
				
				Statement stmt2 = conn.createStatement();
				update = stmt2.executeUpdate("UPDATE inventory SET safetyStock = '"+safeQuantity+"' WHERE id = '"+b+"'");
				stmt2.close();
			}
			
			stmt.close();
			System.out.println("end");
			
		}catch(SQLException e) {
			System.out.println("Exception: " + e.toString());
			throw new ExceptionInInitializerError(e);
		}
		
		
	}
}
