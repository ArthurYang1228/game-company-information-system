package models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class CustomerDAO {
private Connection conn;
	
	public CustomerDAO(Connection conn) {
		this.conn = conn;
	}
	
	public ArrayList<Customer> getAllCustomers() {
		try {
			ArrayList<Customer> customers = new ArrayList<Customer>();
			
			Statement stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(
				"SELECT id, name, phone, address, birthdate, gender FROM customer"
			);
			while(rs.next()) {
				customers.add(
					new Customer(
							rs.getInt("id"), rs.getString("name"), 
							rs.getString("phone"), rs.getString("address"),
							rs.getString("birthdate"), rs.getInt("gender")
					)
				);
			}
			return customers;
		}
		catch(SQLException e) {
			throw new ExceptionInInitializerError(e);
		} 
	}
	
	public Customer getCustomer(int id) {
		try {
			PreparedStatement stmt = conn.prepareStatement(
				"SELECT name, phone, address, birthdate, gender FROM customer WHERE id=?"
			);
			stmt.setInt(1, id);
			ResultSet rs = stmt.executeQuery();
			if(rs.next())
				return new Customer(id, rs.getString("name"), 
						rs.getString("phone"), rs.getString("address"),
						rs.getString("birthdate"), rs.getInt("gender"));
			else
				System.out.println("Records not found");
				return null;
		}
		catch(SQLException e) {
			throw new ExceptionInInitializerError(e);
		} 
	}
	
	public Customer insert(Customer customer) {
		try {
			PreparedStatement stmt = conn.prepareStatement(
				"INSERT INTO customer ( name, phone, address, birthdate, gender) VALUES (?, ?, ?, ?, ?);"//, 
			//	Statement.RETURN_GENERATED_KEYS
			);
			stmt.setString(1, customer.name);
			stmt.setString(2, customer.phone);
			stmt.setString(3, customer.address);
			stmt.setString(4, customer.birthdate);
			stmt.setInt(5, customer.gender);
			
			int insertedId = stmt.executeUpdate();
			customer.id = insertedId;
			return customer;
		}
		catch(SQLException e) {
			System.out.println("Exception: " + e.toString());
			throw new ExceptionInInitializerError(e);
		} 
	}
	
	public boolean update(Customer customer) {
		try {
			PreparedStatement stmt = conn.prepareStatement(
				"Update customer SET name=?, phone=?, address=?, birthdate=?, gender=? WHERE id=?;"
			);
			stmt.setString(1, customer.name);
			stmt.setString(2, customer.phone);
			stmt.setString(3, customer.address);
			stmt.setString(4, customer.birthdate);
			stmt.setInt(5, customer.gender);
			stmt.setInt(6, customer.id);
			
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
	
	public boolean delete(Customer customer) {
		try {
			PreparedStatement stmt = conn.prepareStatement(
				"DELETE FROM customer WHERE id=?;"
			);
			stmt.setInt(1, customer.id);
			
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
	
	public ArrayList<Customer> search(String customerName) {
		try {
			ArrayList<Customer> customers = new ArrayList<Customer>();
			PreparedStatement stmt = conn.prepareStatement(
				"SELECT id, name, phone, address, birthdate, gender FROM customer WHERE name LIKE ?;"
			);
			stmt.setString(1, "%" + customerName + "%");
			ResultSet rs = stmt.executeQuery();
			while(rs.next()) {
				customers.add(
					new Customer(
						rs.getInt("id"), rs.getString("name"), 
						rs.getString("phone"), rs.getString("address"),
						rs.getString("birthdate"), rs.getInt("gender")
					)
				);
			}
			return customers;
		}
		catch(SQLException e) {
			System.out.println("Exception: " + e.toString());
			throw new ExceptionInInitializerError(e);
		}
	}
}
