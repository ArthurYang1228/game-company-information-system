package models;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;


public class turnover {

	
	public int start;
	public int end;
	public int cost;
	public Connection conn = Connector.getConn();
	
	public turnover(){
		try{
		this.conn = Connector.getConn();
		Statement stmt = conn.createStatement();
		
		ResultSet rs = stmt.executeQuery(
			"SELECT start, end, cost FROM turnover"
		);
			while(rs.next()){
			this.start = rs.getInt("start");
			this.end = rs.getInt("end");
			this.cost = rs.getInt("cost");
			}
		}
		catch(SQLException e) {
			System.out.println("no");
			throw new ExceptionInInitializerError(e);
		} 
		
	}
	
	public boolean setCost(float price, int number){
		cost += price*number;
		
		try {
			PreparedStatement stmt = conn.prepareStatement(
				"Update turnover SET cost=? WHERE id=1;"
			);
			
			stmt.setInt(1, cost);
			
			
			int affectedRows = stmt.executeUpdate();
			if(affectedRows == 1)
				return true;
			else
				return false;
		}
		catch(SQLException e) {
			System.out.println("Exception: " + e.toString());
			throw new ExceptionInInitializerError(e);
		}
		
	}
	
	public boolean setEnd(float price, int number){
		end += price*number;
		
		try {
			PreparedStatement stmt = conn.prepareStatement(
				"Update turnover SET end=? WHERE id=1;"
			);
			
			stmt.setInt(1, end);
			
			
			int affectedRows = stmt.executeUpdate();
			if(affectedRows == 1)
				return true;
			else
				return false;
		}
		catch(SQLException e) {
			System.out.println("Exception: " + e.toString());
			throw new ExceptionInInitializerError(e);
		}
	}
	
	
	
	public  float getTurnover(){
		int costNow = cost;
		int startNow = start;
		int endNow = end;
		
		start = end;
		cost = 0;
		try {
			PreparedStatement stmt = conn.prepareStatement(
				"Update turnover SET start=?, end=?, cost=?, date=NOW(), turnover=? WHERE id=1;"
			);
			stmt.setInt(1, start);
			stmt.setInt(2, end);
			stmt.setInt(3, cost);
			stmt.setFloat(4, 2*(float)costNow/(startNow + endNow));
			
			
			int affectedRows = stmt.executeUpdate();
		}
		catch(SQLException e) {
			System.out.println("Exception: " + e.toString());
			throw new ExceptionInInitializerError(e);
		}
		
	
		

		return 2*(float)costNow/(startNow + endNow);
		 
	}	
	
	
	
}





