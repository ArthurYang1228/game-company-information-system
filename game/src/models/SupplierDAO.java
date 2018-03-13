package models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class SupplierDAO {
private Connection conn;
	
	public SupplierDAO(Connection conn) {
		this.conn = conn;
	}
	
	public ArrayList<Supplier> getAllSuppliers() {
		try {
			ArrayList<Supplier> suppliers = new ArrayList<Supplier>();
			
			Statement stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(
				"SELECT id, name, phone, address FROM supplier"
			);
			while(rs.next()) {
				suppliers.add(
					new Supplier(
							rs.getInt("id"), rs.getString("name"), 
							rs.getString("phone"), rs.getString("address")
					)
				);
			}
			return suppliers;
		}
		catch(SQLException e) {
			throw new ExceptionInInitializerError(e);
		} 
	}
	
	public Supplier getSupplier(int id) {
		try {
			PreparedStatement stmt = conn.prepareStatement(
				"SELECT name, phone, address FROM supplier WHERE id=?"
			);
			stmt.setInt(1, id);
			ResultSet rs = stmt.executeQuery();
			if(rs.next())
				return new Supplier(id, rs.getString("name"), 
						rs.getString("phone"), rs.getString("address"));
			else
				System.out.println("Records not found");
				return null;
		}
		catch(SQLException e) {
			throw new ExceptionInInitializerError(e);
		} 
	}
	
	public Supplier insert(Supplier supplier) {
		try {
			PreparedStatement stmt = conn.prepareStatement(
				"INSERT INTO Supplier (name, phone, address) VALUES (?, ?, ?);", 
				Statement.RETURN_GENERATED_KEYS
			);
			stmt.setString(1, supplier.name);
			stmt.setString(2, supplier.phone);
			stmt.setString(3, supplier.address);
			
			int insertedId = stmt.executeUpdate();
			supplier.id = insertedId;
			return supplier;
		}
		catch(SQLException e) {
			System.out.println("Exception: " + e.toString());
			throw new ExceptionInInitializerError(e);
		} 
	}
	
	public boolean update(Supplier supplier) {
		try {
			PreparedStatement stmt = conn.prepareStatement(
				"Update Supplier SET name=?, phone=?, address=? WHERE id=?;"
			);
			stmt.setString(1, supplier.name);
			stmt.setString(2, supplier.phone);
			stmt.setString(3, supplier.address);
			stmt.setInt(4, supplier.id);
			
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
	
	public boolean delete(Supplier supplier) {
		try {
			PreparedStatement stmt = conn.prepareStatement(
				"DELETE FROM Supplier WHERE id=?;"
			);
			stmt.setInt(1, supplier.id);
			
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
	
	public ArrayList<Supplier> search(String supplierName) {
		try {
			ArrayList<Supplier> suppliers = new ArrayList<Supplier>();
			PreparedStatement stmt = conn.prepareStatement(
				"SELECT id, name, phone, address FROM Supplier WHERE name LIKE ?;"
			);
			stmt.setString(1, "%" + supplierName + "%");
			ResultSet rs = stmt.executeQuery();
			while(rs.next()) {
				suppliers.add(
					new Supplier(
						rs.getInt("id"), rs.getString("name"), 
						rs.getString("phone"), rs.getString("address")
					)
				);
			}
			return suppliers;
		}
		catch(SQLException e) {
			System.out.println("Exception: " + e.toString());
			throw new ExceptionInInitializerError(e);
		}
	}
}

