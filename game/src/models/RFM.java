package models;

import java.sql.*;
import java.sql.Date;
import java.text.SimpleDateFormat;
import javax.sql.*;
import java.util.*;
import java.lang.Number;

public class RFM {

	private PreparedStatement SQLtoR;
	private PreparedStatement SQLtoM;
	private PreparedStatement insert;
	private PreparedStatement update;
	private PreparedStatement findR;
	private PreparedStatement findF;
	private PreparedStatement findM;
	private PreparedStatement updateRFM;
	private Connection connection;
	
	public RFM() {
	
	try{
		connection = Connector.getConn();
		SQLtoR = connection.prepareStatement("SELECT max(Date) FROM salerecord WHERE customer=?");
		SQLtoM = connection.prepareStatement("SELECT Amount FROM salerecord WHERE customer=?");
		insert = connection.prepareStatement("INSERT INTO rfm"+"(RID,CID,R,F,M)"+"VALUES(?,?,?,?,?)");
		update = connection.prepareStatement("UPDATE rfm SET R=?,F=?,M=? WHERE RID=?");
		findR = connection.prepareStatement("SELECT DateDiff(curdate(),R) FROM RFM WHERE RID=?");
		findF = connection.prepareStatement("SELECT F FROM RFM WHERE RID=?");
		findM = connection.prepareStatement("SELECT M FROM RFM WHERE RID=?");
		updateRFM = connection.prepareStatement("UPDATE rfm SET RFM=? WHERE RID=?");
	}
	catch(SQLException x) {
		x.printStackTrace();
		System.exit(1);
	}

	}

public int GetMoney(String CID) {
	
	int val=0;
	
	try {
		SQLtoM.setString(1 , CID);
		ResultSet rs=SQLtoM.executeQuery(); 

		while (rs.next()){
			val =  val +((Number) rs.getObject(1)).intValue();
		} 
	}catch(SQLException x){
		x.printStackTrace();
	}
	
	return val;
	}

public int GetFrequency(String CID) {
	
	int fre=0;
	
	try{
		SQLtoM.setString(1 , CID);
		ResultSet rs=SQLtoM.executeQuery(); 

		while (rs.next()){
			fre = fre + 1;
		} 
	}catch(SQLException x) {
		x.printStackTrace();
	}
	
	return fre;
	}

public String GetRecency(String CID) {
	
	String Date=null;
	
	try {
		SQLtoR.setString(1 , CID);
		ResultSet rs=SQLtoR.executeQuery(); 

		while (rs.next()){
			Date = rs.getString(1);
		} 
	}catch(SQLException x) {
		x.printStackTrace();
	}
	
	return Date;
	}

public void insert(String CID,String R,int F,int M) {
		try {
		
			Date parseDate = Date.valueOf(R);
			int iCID = Integer.valueOf(CID).intValue();
			
			insert.setInt(1, iCID);
			insert.setInt(2,iCID);
			insert.setDate(3,parseDate);
			insert.setInt(4,F);
			insert.setInt(5,M);
			
			insert.executeUpdate();
		}catch(SQLException x) {
			x.printStackTrace();
		}
	}

public void update(String CID,String R,int F,int M) {
	try {
	
		Date parseDate = Date.valueOf(R);
		int iCID = Integer.valueOf(CID).intValue();
		
		update.setDate(1,parseDate);
		update.setInt(2,F);
		update.setInt(3,M);
		update.setInt(4, iCID);
		
		update.executeUpdate();
	}catch(SQLException x) {
		x.printStackTrace();
	}
}

public String GetRFM(String CID){
	String RFM=null;
	int maxR=0;
	int minR=0;
	int interR=0;
	int date=0;
	int maxF=0;
	int minF=0;
	int interF=0;
	int fre=0;
	int maxM=0;
	int minM=0;
	int interM=0;
	int money=0;
	int R=0;
	int F=0;
	int M=0;
	
	try{
		//calculate R
		Statement st1= connection.createStatement(); 
		String sql1 = "SELECT max(DateDiff(curdate(),R)) FROM RFM;";
		ResultSet rs1=st1.executeQuery(sql1); 
		while(rs1.next()) {
			maxR = rs1.getInt(1);
		}
		
		Statement st2= connection.createStatement(); 
		String sql2 = "SELECT min(DateDiff(curdate(),R)) FROM RFM;";
		ResultSet rs2=st2.executeQuery(sql2); 
		while(rs2.next()) {
			minR = rs2.getInt(1);
		}
		
		interR = (maxR-minR)/3;
		
		findR.setString(1, CID);
		ResultSet rs3=findR.executeQuery(); 
		while(rs3.next()) {
			date = rs3.getInt(1);
		}
		
		R = (date-minR)/interR +1;
		if(R>=3) {
			R=3;
		}
		
		//calculate F
		Statement st4= connection.createStatement(); 
		String sql4 = "SELECT max(F) FROM RFM;";
		ResultSet rs4=st4.executeQuery(sql4); 
		while(rs4.next()) {
			maxF = rs4.getInt(1);
		}
		
		Statement st5= connection.createStatement(); 
		String sql5 = "SELECT min(F) FROM RFM;";
		ResultSet rs5=st5.executeQuery(sql5); 
		while(rs5.next()) {
			minF = rs5.getInt(1);
		}
		
		interF = (maxF-minF)/3;
		
		findF.setString(1, CID);
		ResultSet rs6=findF.executeQuery(); 
		while(rs6.next()) {
			fre = rs6.getInt(1);
		}
		
		F = (maxF-fre)/interF;
		if(F>3) {
			F=3;
		}else if(F<1) {
			F=1;
		}
		
		//calculate M
		Statement st7= connection.createStatement(); 
		String sql7 = "SELECT max(M) FROM RFM;";
		ResultSet rs7=st7.executeQuery(sql7); 
		while(rs7.next()) {
			maxM = rs7.getInt(1);
		}
		
		Statement st8= connection.createStatement(); 
		String sql8 = "SELECT min(M) FROM RFM;";
		ResultSet rs8=st8.executeQuery(sql8); 
		while(rs8.next()) {
			minM = rs8.getInt(1);
		}
		
		interM = (maxM-minM)/3;
		
		findM.setString(1, CID);
		ResultSet rs9=findM.executeQuery(); 
		while(rs9.next()) {
			money = rs9.getInt(1);
		}
		
		M = (maxM-money)/interM;
		if(M>3) {
			M=3;
		}else if(M<1) {
			M=1;
		}
		
		RFM=String.valueOf(100*R+10*F+M);
	
	}catch(SQLException x) {
		x.printStackTrace();
	}
	
	return RFM;
}

public void updateRFM(String CID,String RFM) {
	try {
	
		int iCID = Integer.valueOf(CID).intValue();
		int iRFM = Integer.valueOf(RFM).intValue();
		
		updateRFM.setInt(1,iRFM);
		updateRFM.setInt(2, iCID);
		
		updateRFM.executeUpdate();
	}catch(SQLException x) {
		x.printStackTrace();
	}
}
}

