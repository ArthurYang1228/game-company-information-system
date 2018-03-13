package models;


import java.sql.*;
import java.util.*;




public class predict {
	public Connection conn;
	
	public predict(Connection conn){
		this.conn = conn;
	}
	
	
	
	public double indexPredict(double accArray, double exp, double index ){
		
		return  exp+index*(accArray-exp);
		
	}
	
	public double[] predictList(double[] acc, double index){
		
		double[] exp = new double[acc.length-1];
		
		
		exp[1] = acc[0];
		for(int i = 2; i<exp.length; i++ ){
			exp[i] = indexPredict(acc[i-1], exp[i-1], index);
			
		}
		return exp;
	}
	
	public double[] getSale(int id){
		try{
			Statement stmt = conn.createStatement();
			String sql = "SELECT * FROM inventory";
			ResultSet rst=stmt.executeQuery(sql);
			ArrayList IDs = new ArrayList();
			
			
			rst.close();
			
			double[] acc = new double[15];
				
				Statement stmt2 = conn.createStatement();
				String sql2 = "SELECT DATEDIFF( NOW(),time) AS DiffDate, quantity FROM salerecord WHERE inventory = '"+ id +"'";
				ResultSet rst2=stmt2.executeQuery(sql2);
			
				
				while(rst2.next()) {
				
					int i = rst2.getInt("DiffDate");
					if(i <15 && acc[i]== 0)
						acc[i] = rst2.getInt("quantity");
					
					else if(i <15 && acc[i] != 0)
						acc[i] += rst2.getInt("quantity");
					else
						break;
					
				}
				return acc;
		
		
		
		
			
		}catch(SQLException e) {
			System.out.println("Exception: " + e.toString());
			throw new ExceptionInInitializerError(e);
		}
		
	}
	
	public ArrayList<Integer> getAllID(){
		try{
			Statement stmt = conn.createStatement();
			String sql = "SELECT * FROM inventory";
			ResultSet rst=stmt.executeQuery(sql);
			ArrayList IDs = new ArrayList();
			while(rst.next()){
				IDs.add(rst.getInt("id"));
			}
			return IDs;
			
		}catch(SQLException e) {
			System.out.println("Exception: " + e.toString());
			throw new ExceptionInInitializerError(e);
		}
			
			
		
	}
	
	public double getDif(double[] exp, double[] acc){
		double dif = 0;
		for(int i=0; i<exp.length; i++){
			dif += Math.pow(2, exp[i]-acc[i]);
			
		}
		return dif;
	}
	
	public double getIndex(int id){
			double[] a = new double[2];
			a[0] = 0;
			a[1] = getDif(predictList(getSale(id), 0), getSale(id));
		for(double i=0;i<=1;i+=0.05){
			if(getDif(predictList(getSale(id), i), getSale(id)) < a[1]){
				a[0] = i;
				a[1] = getDif(predictList(getSale(id), i), getSale(id));
				
			}
				
			
			}
		return a[0];
	}
	
	public void setSalePerDay(int id){
		try {
			PreparedStatement stmt = conn.prepareStatement(
				"Update Inventory SET salesPerDay=? WHERE id=? ;"
			);
			double[] acc = getSale(id);
			double[] exp = predictList(acc, getIndex(id));
			double index = getIndex(id);
			stmt.setDouble(1, indexPredict(acc[acc.length-1],exp[exp.length-1],index));
			stmt.setInt(2, id);
			
			
		}
		catch(SQLException e) {
			System.out.println("Exception: " + e.toString());
			throw new ExceptionInInitializerError(e);
		}
		
		
	} 
	
	
	
	
}
