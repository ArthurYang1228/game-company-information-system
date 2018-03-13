package models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class SaleRecordDAO {
	private Connection conn;
	
	public SaleRecordDAO(Connection conn) {
		this.conn = conn;
	}
	
	public ArrayList<SaleRecord> getAllSaleRecords() {
		try {
			ArrayList<SaleRecord> saleRecords = new ArrayList<SaleRecord>();
			
			Statement stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(
				"SELECT id, quantity, inventory, time, customer, price FROM SaleRecord"
			);
			while(rs.next()) {
				saleRecords.add(
					new SaleRecord(
						rs.getInt("id"), rs.getInt("quantity"), 
						rs.getInt("inventory"),//new InventoryDAO(conn).getInventory(rs.getInt("id")), 
						rs.getString("time"), rs.getInt("customer"), //new CustomerDAO(conn).getCustomer(rs.getInt("id")),
						rs.getInt("price"))
					);
			}
			return saleRecords;
		}
		catch(SQLException e) {
			throw new ExceptionInInitializerError(e);
		}
	}
	
//	public ArrayList<SaleRecord> getAllByOrder(Order order) {
//		try {
//			ArrayList<SaleRecord> saleRecords = new ArrayList<SaleRecord>();
//			
//			PreparedStatement stmt = conn.prepareStatement(
//				"SELECT id, sugar, ice, productId FROM SaleRecord WHERE orderId=?"
//			);
//			stmt.setInt(1, order.id);
//			ResultSet rs = stmt.executeQuery();
//			
//			while(rs.next()) {
//				saleRecords.add(
//					new SaleRecord(
//						rs.getInt("id"), rs.getString("sugar"), rs.getString("ice"), 
//						new ProductDAO(conn).getProduct(rs.getInt("productId"))
//					)
//				);
//			}
//			return saleRecords;
//		}
//		catch(SQLException e) {
//			throw new ExceptionInInitializerError(e);
//		}
//	}
	
	public SaleRecord get(int id) {
		try {
			PreparedStatement stmt = conn.prepareStatement(
					"SELECT id, quantity, inventory, time, customer, price FROM SaleRecord WHERE id=?"
			);
			stmt.setInt(1, id);
			ResultSet rs = stmt.executeQuery();
			if(rs.next())
				return new SaleRecord(
						rs.getInt("id"), rs.getInt("quantity"), 
						rs.getInt("inventory"),//new InventoryDAO(conn).getInventory(rs.getInt("id")), 
						rs.getString("time"), rs.getInt("customer"), //new CustomerDAO(conn).getCustomer(rs.getInt("id")),
						rs.getInt("price"));
			else
				System.out.println("Records not found");
				return null;
		}
		catch(SQLException e) {
			throw new ExceptionInInitializerError(e);
		}
	}
	
	public SaleRecord insert(SaleRecord saleRecord) {
		try {
			PreparedStatement stmt = conn.prepareStatement(
				"INSERT INTO SaleRecord (quantity, inventory, time, customer, price) VALUES (?, ?, ?, ?, ?);", 
				Statement.RETURN_GENERATED_KEYS
			);
			stmt.setInt(1, saleRecord.quantity);
			stmt.setInt(2, saleRecord.inventory);
			stmt.setString(3, saleRecord.time);
			stmt.setInt(4, saleRecord.customer);
			stmt.setInt(5, saleRecord.price);
			stmt.executeUpdate();
//			PreparedStatement stmt2 = conn.prepareStatement(
//					"UPDATE INTO SaleRecord (quantity, inventory, time, customer, price) VALUES (?, ?, ?, ?, ?);", 
//					Statement.RETURN_GENERATED_KEYS
//				);
			ResultSet rs = stmt.getGeneratedKeys();
			if (rs.next()){
				saleRecord.id = rs.getInt(1);
			}
			return saleRecord;
		}
		catch(SQLException e) {
			System.out.println("Exception: " + e.toString());
			throw new ExceptionInInitializerError(e);
		} 
	}
	public ArrayList<SaleRecord> search(int search) {
		try {
			ArrayList<SaleRecord> saleRecords = new ArrayList<SaleRecord>();
			PreparedStatement stmt = conn.prepareStatement(
				"SELECT quantity, inventory, time, customer, price FROM salerecord WHERE id=?;"
			);
			stmt.setInt(1, search );
			ResultSet rs = stmt.executeQuery();
			while(rs.next()) {
				saleRecords.add(
					new SaleRecord(search, rs.getInt("quantity"),
							rs.getInt("inventory"), rs.getString("time"),
							rs.getInt("customer"), rs.getInt("price")
					)
				);
			}
			return saleRecords;
		}
		catch(SQLException e) {
			System.out.println("Exception: " + e.toString());
			throw new ExceptionInInitializerError(e);
		}
	}
	public SaleRecord getSaleRecord(int id) {
		try {
			PreparedStatement stmt = conn.prepareStatement(
				"SELECT quantity, inventory, time, customer, price FROM salerecord WHERE id=?"
			);
			stmt.setInt(1, id);
			ResultSet rs = stmt.executeQuery();
			if(rs.next())
				return new SaleRecord(id, rs.getInt("quantity"), 
						rs.getInt("inventory"), rs.getString("time"),
						rs.getInt("customer"), rs.getInt("price"));
			else
				System.out.println("Records not found");
				return null;
		}
		catch(SQLException e) {
			throw new ExceptionInInitializerError(e);
		} 
	}
	
//	public SaleRecord insertByOrder(SaleRecord saleRecord, Order order) {
//		try {
//			PreparedStatement stmt = conn.prepareStatement(
//				"INSERT INTO SaleRecord (sugar, ice, productId, orderId) VALUES (?, ?, ?, ?);", 
//				Statement.RETURN_GENERATED_KEYS
//			);
//			stmt.setString(1, saleRecord.sugar);
//			stmt.setString(2, saleRecord.ice);
//			stmt.setInt(3, saleRecord.product.id);
//			stmt.setInt(4, order.id);
//			
//			stmt.executeUpdate();
//			ResultSet rs = stmt.getGeneratedKeys();
//			if (rs.next()){
//				saleRecord.id = rs.getInt(1);
//			}
//			return saleRecord;
//		}
//		catch(SQLException e) {
//			System.out.println("Exception: " + e.toString());
//			throw new ExceptionInInitializerError(e);
//		} 
//	}
	
//	public boolean update(SaleRecord saleRecord) {
//		try {
//			PreparedStatement stmt = conn.prepareStatement(
//				"Update SaleRecord SET sugar=?, ice=?, productId=? WHERE id=?;"
//			);
//			stmt.setString(1, saleRecord.sugar);
//			stmt.setString(2, saleRecord.ice);
//			stmt.setInt(3, saleRecord.product.id);
//			stmt.setInt(4, saleRecord.id);
//			
//			int affectedRows = stmt.executeUpdate();
//			if(affectedRows == 1)
//				return true;
//			else
//				return false;
//		}
//		catch(SQLException e) {
//			System.out.println("Exception: " + e.toString());
//			throw new ExceptionInInitializerError(e);
//		}
//	}
	
	public boolean delete(SaleRecord saleRecord) {
		try {
			PreparedStatement stmt = conn.prepareStatement(
				"DELETE FROM SaleRecord WHERE id=?;"
			);
			stmt.setInt(1, saleRecord.id);
			
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
	
//	public boolean deleteByOrder(Order order) {
//		try {
//			PreparedStatement stmt = conn.prepareStatement(
//				"DELETE FROM SaleRecord WHERE orderId=?;"
//			);
//			stmt.setInt(1, order.id);
//			
//			int affectedRows = stmt.executeUpdate();
//			if(affectedRows >= 1)
//				return true;
//			else
//				return false;
//		}
//		catch(SQLException e) {
//			System.out.println("Exception: " + e.toString());
//			throw new ExceptionInInitializerError(e);
//		}
//	}
	
}
