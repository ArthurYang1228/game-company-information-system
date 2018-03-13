package marketing;

import java.sql.*;
import java.sql.Date;
import java.text.SimpleDateFormat;
import javax.sql.*;
import java.util.*;
import java.lang.Number;
import java.text.NumberFormat;

public class BEI {
	
	private PreparedStatement RFMRes;
	private PreparedStatement updateBEI;
	private PreparedStatement checkRFM;
	private Connection connection;
	private double BE;
	
	public  BEI(int profit,int cost) {
	
	try{
		connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/database","root","1234");
		RFMRes = connection.prepareStatement("SELECT response FROM BEI WHERE RFM=?");
		updateBEI = connection.prepareStatement("UPDATE bei SET BEI=? WHERE RFM=?");
		checkRFM = connection.prepareStatement("SELECT * FROM BEI WHERE RFM=?");
		
		double p=0.0;
		double BE=0.0;
		
		//calculate BE
		p = cost*1.0/profit;
		NumberFormat nf = NumberFormat.getInstance();
		nf.setMinimumFractionDigits(1);
		BE = Double.parseDouble(nf.format(p));
		this.BE=BE;
	}
	catch(SQLException x) {
		x.printStackTrace();
		System.exit(1);
	}
	}
	
	public String GetBEI(String RFM) {
		
		int sval=0;
		int scou=0;
		double sp=0.0;
		double sBE=0.0;
		double sBEI=0.0;
		String BEI=null;

		
		try {

			//calculate 各組回應率
			RFMRes.setString(1 , RFM);
			ResultSet rs=RFMRes.executeQuery(); 

			while (rs.next()){
				sval =  sval +((Number) rs.getObject(1)).intValue();
				scou = scou +1;	
			} 
			
			sp = sval*1.0/scou;
			NumberFormat nf = NumberFormat.getInstance();
			nf.setMinimumFractionDigits(1);
			sBE = Double.parseDouble(nf.format(sp));
			
			sBEI = ((sBE-this.BE)/this.BE);
			BEI = nf.format(sBEI);
			
		}catch(SQLException x){
			x.printStackTrace();
		}
		return BEI;
		}
	
	public void updateRFM(String BEI,String RFM) {
		try {
		
			double dBEI = Double.valueOf(BEI).doubleValue();
			int iRFM = Integer.valueOf(RFM).intValue();
			
			updateBEI.setDouble(1,dBEI);
			updateBEI.setInt(2, iRFM);
			
			updateBEI.executeUpdate();
		}catch(SQLException x) {
			x.printStackTrace();
		}
	}

	public int checkRFM(String RFM) {
		int result=0;
		
		try {
			
			checkRFM.setString(1, RFM);
			ResultSet rs=checkRFM.executeQuery();
			
			while (rs.next()){
				result = 1;
			} 
		}catch(SQLException x) {
			x.printStackTrace();
		}
		
		return result;
	}
	
	public double getBE() {
		return BE;
	}
}
