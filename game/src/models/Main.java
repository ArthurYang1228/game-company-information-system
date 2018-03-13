package models;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.*;
import java.util.Date;

import models.Connector;
import java.sql.Connection;

public class Main {
	public static void main(String[] args) {
		
		 Connection conn = Connector.getConn();
		 try{
		    Statement stmt = conn.createStatement();
		    
		    ResultSet rs1 = stmt.executeQuery("SELECT DATEDIFF(month, NOW(), date) AS DiffDate FROM turnover WHERE id=1");
		    if(rs1.next())
		    	System.out.println(rs1.getInt("DiffDate"));
	
		 }catch(SQLException e) {
				System.out.println("Exception: " + e.toString());
				
			}
			
		}
}
	
	
	
	

