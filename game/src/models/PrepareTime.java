package models;

import java.sql.*;
import java.util.Date;

public class PrepareTime {
	
	private Connection conn;
	
	public PrepareTime(Connection conn) {
		this.conn = conn;
	}
	
	public void Compute() {
		try {
			
			Statement stmt = conn.createStatement();
			String sql = "SELECT * FROM inventory";
			ResultSet rst=stmt.executeQuery(sql);
			
			rst.last();
			int idlength = rst.getInt("id");
			int inventory[] = new int [idlength];
			
			for(int i=0;i<(idlength-1);i++) {
				
				inventory[i] = i+1;
				
			}
			
			for(int j=0;j<(idlength-1);j++) {
				
				Statement stmt2 = conn.createStatement();
				String sql2 = "SELECT DATEDIFF(arrDate, ordDate) AS DiffDate FROM purchasedetailed WHERE inventoryID = '"+inventory[j]+"'";
				ResultSet rst2=stmt2.executeQuery(sql2);
				
				int total = 0;
				int count = 0;
				
				while(rst2.next()) {
					
					int a = rst2.getInt("DiffDate");
					total += a;
					count++;
				}
				
				double average = total;
				
				if(count!=0) {
					average /= count;
				}
				rst2.beforeFirst();
				
				double sdtotal = 0;
				double sd = 0;
				
				if(count <= 1) {
					sd = 0;
				}else {
					while(rst2.next()) {
						
						double b = rst2.getInt("DiffDate");
						sdtotal += Math.pow(b-average, 2);
					}
					
					sd = Math.sqrt(sdtotal/(count-1));
					
				}
				rst2.close();
				stmt2.close();
				
				int update = 0;
				Statement stmt3 = conn.createStatement();
				update = stmt3.executeUpdate("Update inventory SET orderTime ='"+average+"' WHERE id ='"+inventory[j]+"'");
				stmt3.close();
				Statement stmt4 = conn.createStatement();
				update = stmt4.executeUpdate("Update inventory SET sd ='"+sd+"' WHERE id ='"+inventory[j]+"'");
				stmt4.close();
				System.out.println("finish");
			}
			
		}catch(SQLException e) {
			System.out.println("Exception: " + e.toString());
			throw new ExceptionInInitializerError(e);
		}
	}
	
}
