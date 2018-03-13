package models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;



public class PurchaseDAO {
	private Connection conn;
	
	public PurchaseDAO(Connection conn) {
		this.conn = conn;
	}
	
	public ArrayList<Purchase> getAllPurchases() {
		try {
			ArrayList<Purchase> purchases = new ArrayList<Purchase>();
			
			Statement stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(
				"SELECT Purchase.id, `date`, PurchaseDetailed.id, quantity, totalPrice, inventoryId, supplierId, arrDate FROM Purchase, PurchaseDetailed "
				+ "WHERE Purchase.id = purchaseId"
			);
			if(rs.next()) {
				int lastPurchaseId = rs.getInt("Purchase.Id");
				
				Purchase p = new Purchase(rs.getInt("Purchase.id"), rs.getString("date")
						);
				
				while(true) {
					if(rs.getInt("Purchase.Id") != lastPurchaseId){
						lastPurchaseId = rs.getInt("Purchase.Id");
						purchases.add(p);
						p = new Purchase(
							rs.getInt("Purchase.id"), rs.getString("date")
						);
					}
					p.addPurchaseDetailed(
						new PurchaseDetailed(
								rs.getInt("PurchaseDetailed.id"), 
								rs.getInt("quantity"), rs.getInt("totalPrice"), 
								new InventoryDAO(conn).getInventory(rs.getInt("inventoryId")), 
								new SupplierDAO(conn).getSupplier(rs.getInt("supplierId")), rs.getString("arrDate"))
					);
					if(!rs.next()) {
						purchases.add(p);
						break;
					}
				}
			}
			return purchases;
			
		}
		catch(SQLException e) {
			throw new ExceptionInInitializerError(e);
		}
	}
	
	
	public Purchase get(int id) {
		try {
			Purchase purchase;
			
			PreparedStatement stmt = conn.prepareStatement(
				"SELECT id, `date`, FROM Purchase WHERE id=?"
			);
			stmt.setInt(1, id);
			
			ResultSet rs = stmt.executeQuery();
			if(rs.next()) {
				purchase = new Purchase(
					rs.getInt("id"), rs.getString("date")
				);
				
				PurchaseDetailedDAO pDDAO = new PurchaseDetailedDAO(conn);
				for(PurchaseDetailed pd: pDDAO.getAllByPurchase(purchase)) {
					purchase.addPurchaseDetailed(pd);
				}
				
				return purchase; 
			}
			else {
				System.out.println("Records not found");
				return null;
			}
		}
		catch(SQLException e) {
			throw new ExceptionInInitializerError(e);
		}
	}
	
	public Purchase insert(Purchase p) {
		try {
			// insert Purchase
			PreparedStatement stmt = conn.prepareStatement(
				"INSERT INTO Purchase (`date`) VALUES (?);", 
				Statement.RETURN_GENERATED_KEYS
			);
			stmt.setString(1, p.date);
			
			
			stmt.executeUpdate();
			ResultSet rs = stmt.getGeneratedKeys();
			if (rs.next()){
			    p.id = rs.getInt(1);
			}
			
			// insert PurchaseDetailed
			PurchaseDetailedDAO purchaseDetailedDAO = new PurchaseDetailedDAO(conn);
			for(PurchaseDetailed pd: p.purchaseDetailedList) {
				purchaseDetailedDAO.insertByPurchase(pd, p);
			}
			return p;
		}
		catch(SQLException e) {
			System.out.println("Exception: " + e.toString());
			throw new ExceptionInInitializerError(e);
		} 
	}
	
	public boolean update(Purchase p) {
		try {
			// update purchase
			PreparedStatement stmt = conn.prepareStatement(
				"Update Purchase SET `date`=?,  WHERE id=?;"
			);
			stmt.setString(1, p.date);
			
			stmt.setInt(2, p.id);
			int affectedRows = stmt.executeUpdate();
			
			// update purchaseDetailed
			PurchaseDetailedDAO purchaseDetailedDAO = new PurchaseDetailedDAO(conn);
			
			// clean
			purchaseDetailedDAO.deleteByPurchase(p);
			
			// insert
			for(PurchaseDetailed pd: p.purchaseDetailedList) {
				purchaseDetailedDAO.insertByPurchase(pd, p);
			}
			
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
	
	public boolean delete(Purchase p) {
		try {
			// delete purchase
			PreparedStatement stmt = conn.prepareStatement(
				"DELETE FROM Purchase WHERE id=?;"
			);
			stmt.setInt(1, p.id);
			
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
	
	public ArrayList<Purchase> search(String purchaseDate) {
		try {
			ArrayList<Purchase> purchases = new ArrayList<Purchase>();
			PreparedStatement stmt = conn.prepareStatement(
				"SELECT id, `date` FROM Purchase WHERE `date` LIKE ?;"
			);
			stmt.setString(1, "%" + purchaseDate + "%");
			ResultSet rs = stmt.executeQuery();
			while(rs.next()) {
					Purchase purchase = new Purchase(
							rs.getInt("id"), rs.getString("date")
					);
					purchase.purchaseDetailedList = new PurchaseDetailedDAO(conn).getAllByPurchase(purchase);
					purchases.add(purchase);
			}
			return purchases;
		}
		catch(SQLException e) {
			System.out.println("Exception: " + e.toString());
			throw new ExceptionInInitializerError(e);
		}
	}
}