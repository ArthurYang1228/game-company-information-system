package models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;


public class PurchaseDetailedDAO {
	private Connection conn;
	
	public PurchaseDetailedDAO(Connection conn) {
		this.conn = conn;
	}
	
	public ArrayList<PurchaseDetailed> getAllPurchaseDetaileds() {
		try {
			ArrayList<PurchaseDetailed> purchaseDetaileds = new ArrayList<PurchaseDetailed>();
			
			Statement stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(
				"SELECT id, quantity, totalPrice, inventoryId, supplierId FROM PurchaseDetailed"
			);
			while(rs.next()) {
				purchaseDetaileds.add(
					new PurchaseDetailed(
						rs.getInt("id"), rs.getInt("quantity"), rs.getInt("totalPrice"), 
						new InventoryDAO(conn).getInventory(rs.getInt("inventoryId")),
						new SupplierDAO(conn).getSupplier(rs.getInt("supplierId"))
					)
				);
			}
			return purchaseDetaileds;
		}
		catch(SQLException e) {
			throw new ExceptionInInitializerError(e);
		}
	}
	
	public ArrayList<PurchaseDetailed> getAllByPurchase(Purchase purchase) {
		try {
			ArrayList<PurchaseDetailed> purchaseDetaileds = new ArrayList<PurchaseDetailed>();
			
			PreparedStatement stmt = conn.prepareStatement(
				"SELECT * FROM PurchaseDetailed WHERE purchaseId=?"
			);
			stmt.setInt(1, purchase.id);
			ResultSet rs = stmt.executeQuery();
			
			while(rs.next()) {
				purchaseDetaileds.add(
					new PurchaseDetailed(
						rs.getInt("id"), rs.getInt("quantity"), rs.getInt("totalPrice"), 
						new InventoryDAO(conn).getInventory(rs.getInt("inventoryId")),
						new SupplierDAO(conn).getSupplier(rs.getInt("supplierId")), rs.getString("arrDate")
					)
				);
			}
			return purchaseDetaileds;
		}
		catch(SQLException e) {
			throw new ExceptionInInitializerError(e);
		}
	}
	
	public PurchaseDetailed get(int id) {
		try {
			PreparedStatement stmt = conn.prepareStatement(
				"SELECT id, quantity, totalPrice, inventoryId, supplierId FROM PurchaseDetailed WHERE id=?"
			);
			stmt.setInt(1, id);
			ResultSet rs = stmt.executeQuery();
			if(rs.next())
				return new PurchaseDetailed(
					rs.getInt("id"), rs.getInt("quantity"), rs.getInt("totalPrice"), 
					new InventoryDAO(conn).getInventory(rs.getInt("inventoryId")),
					new SupplierDAO(conn).getSupplier(rs.getInt("supplierId"))
				);
			else
				System.out.println("Records not found");
				return null;
		}
		catch(SQLException e) {
			throw new ExceptionInInitializerError(e);
		}
	}
	
	public PurchaseDetailed insert(PurchaseDetailed purchaseDetailed) {
		try {
			PreparedStatement stmt = conn.prepareStatement(
				"INSERT INTO PurchaseDetailed (quantity, totalPrice, inventoryId, supplierId, ordDate ) VALUES (?, ?, ?, ?, NOW());", 
				Statement.RETURN_GENERATED_KEYS
			);
			stmt.setInt(1, purchaseDetailed.quantity);
			stmt.setInt(2, purchaseDetailed.totalPrice);
			stmt.setInt(3, purchaseDetailed.inventory.id);
			stmt.setInt(4, purchaseDetailed.supplier.id);
			stmt.executeUpdate();
			int Iid = purchaseDetailed.inventory.id;
			
			
			
			ResultSet rss = stmt.executeQuery(
					"SELECT * FROM inventory WHERE id=" + String.valueOf(Iid)
				);
			int totalCost = 0;
			
			
			if(rss.next())
				totalCost = rss.getInt("cost") * rss.getInt("quantity");
			
			totalCost += purchaseDetailed.totalPrice;
			rss.close();
			
			PreparedStatement stmt2 = conn.prepareStatement(
					"Update inventory SET cost=? WHERE id="+ String.valueOf(Iid) + ";"
				);
			stmt2.setInt(1, totalCost/(rss.getInt("quantity")+purchaseDetailed.quantity));
			stmt2.executeUpdate();
			stmt.close();
			
			
			
			ResultSet rs = stmt.getGeneratedKeys();
			if (rs.next()){
				purchaseDetailed.id = rs.getInt(1);
			}
			return purchaseDetailed;
		}
		catch(SQLException e) {
			System.out.println("Exception: " + e.toString());
			throw new ExceptionInInitializerError(e);
		} 
	}
	
	public PurchaseDetailed insertByPurchase(PurchaseDetailed purchaseDetailed, Purchase purchase) {
		try {
			PreparedStatement stmt = conn.prepareStatement(
				"INSERT INTO PurchaseDetailed (quantity, totalPrice, inventoryId, supplierId, purchaseId, ordDate) VALUES (?, ?, ?, ?, ?, NOW());", 
				Statement.RETURN_GENERATED_KEYS
			);
			stmt.setInt(1, purchaseDetailed.quantity);
			stmt.setInt(2, purchaseDetailed.totalPrice);
			stmt.setInt(3, purchaseDetailed.inventory.id);
			stmt.setInt(4, purchaseDetailed.supplier.id);
			stmt.setInt(5, purchase.id);
			
			stmt.executeUpdate();
			ResultSet rs = stmt.getGeneratedKeys();
			if (rs.next()){
				purchaseDetailed.id = rs.getInt(1);
			}
			System.out.println("finish 1");
			stmt.close();
			
			Statement stmt2 = conn.createStatement();
			ResultSet rss = stmt2.executeQuery(
					"SELECT * FROM inventory WHERE id=" + String.valueOf(purchaseDetailed.inventory.id)
				);
			float totalCost = 0;
			int number = 0;
			if(rss.next()){
				totalCost = rss.getFloat("cost") * rss.getInt("quantity");
				number = rss.getInt("quantity");
			}
			totalCost += purchaseDetailed.totalPrice;
			System.out.println(totalCost);
			rss.close();
			stmt2.close();
			
			PreparedStatement stmt3 = conn.prepareStatement(
					"Update inventory SET cost=? WHERE id=?;"
				);
			float realCost = totalCost/(number+purchaseDetailed.quantity);
			stmt3.setFloat(1, realCost);
			stmt3.setString(2, String.valueOf(purchaseDetailed.inventory.id));
			stmt3.executeUpdate();
			System.out.println(realCost);
			stmt3.close();
			
			
			
			return purchaseDetailed;
		}
		catch(SQLException e) {
			System.out.println("Exception: " + e.toString());
			throw new ExceptionInInitializerError(e);
		} 
	}
	
	public boolean update(PurchaseDetailed purchaseDetailed) {
		try {
			PreparedStatement stmt = conn.prepareStatement(
				"Update PurchaseDetailed SET quantity=?, totalPrice=?, inventoryId=?, supplierId=? WHERE id=?;"
			);
			stmt.setInt(1, purchaseDetailed.quantity);
			stmt.setInt(2, purchaseDetailed.totalPrice);
			stmt.setInt(3, purchaseDetailed.inventory.id);
			stmt.setInt(4, purchaseDetailed.supplier.id);
			stmt.setInt(5, purchaseDetailed.id);
			
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
	
	public boolean delete(PurchaseDetailed purchaseDetailed) {
		try {
			PreparedStatement stmt = conn.prepareStatement(
				"DELETE FROM PurchaseDetailed WHERE id=?;"
			);
			stmt.setInt(1, purchaseDetailed.id);
			
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
	
	public boolean deleteByPurchase(Purchase purchase) {
		try {
			PreparedStatement stmt = conn.prepareStatement(
				"DELETE FROM PurchaseDetailed WHERE purchaseId=?;"
			);
			stmt.setInt(1, purchase.id);
			
			int affectedRows = stmt.executeUpdate();
			if(affectedRows >= 1)
				return true;
			else
				return false;
		}
		catch(SQLException e) {
			System.out.println("Exception: " + e.toString());
			throw new ExceptionInInitializerError(e);
		}
	}
	
	public boolean checkArr(int id){
		try{
			PreparedStatement stmt = conn.prepareStatement(
					"Update PurchaseDetailed SET arrDate=NOW() WHERE id=?;"
				);
			stmt.setInt(1, id);
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
	
}