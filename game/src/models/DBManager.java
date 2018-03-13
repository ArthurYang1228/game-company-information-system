package models;

import java.sql.*;

public class DBManager {
	private Connection conn;
	
	public DBManager(Connection conn) {
		this.conn = conn; 
	}
	
	public void createAllTables() {
		createEmployeeTable();
		createInventoryTable();
		createProductTable();
		createOrderTable();
		createOrderDetailedTable();
		createSupplierTable();
		createPurchaseTable();
		createPurchaseDetailedTable();
		createConsumeTable();
	}
	
	private void createEmployeeTable() {
		try {
			Statement stmt = conn.createStatement();
			int affectedRows = stmt.executeUpdate(
				"CREATE TABLE IF NOT EXISTS Employee ("
				+ "id INT AUTO_INCREMENT PRIMARY KEY, "
				+ "name VARCHAR(30), workingHours INT, hourlySalary INT);"
			);
			if(affectedRows >= 1)
				System.out.println("Success");
		}
		catch(SQLException e) {
			System.out.println(e.toString());
			throw new ExceptionInInitializerError(e);
		} 
	}
	
	private void createInventoryTable() {
		try {
			Statement stmt = conn.createStatement();
			int affectedRows = stmt.executeUpdate(
				"CREATE TABLE IF NOT EXISTS Inventory ("
				+ "id INT AUTO_INCREMENT PRIMARY KEY, "
				+ "name VARCHAR(20), quantity INT, safetyStock INT);"
			);
			if(affectedRows >= 1)
				System.out.println("Success");
		}
		catch(SQLException e) {
			System.out.println(e.toString());
			throw new ExceptionInInitializerError(e);
		} 
	}
	
	private void createProductTable() {
		try {
			Statement stmt = conn.createStatement();
			int affectedRows = stmt.executeUpdate(
				"CREATE TABLE IF NOT EXISTS Product ("
				+ "id INT AUTO_INCREMENT PRIMARY KEY, "
				+ "name VARCHAR(30), size VARCHAR(20), price INT);"
			);
			if(affectedRows >= 1)
				System.out.println("Success");
		}
		catch(SQLException e) {
			System.out.println(e.toString());
			throw new ExceptionInInitializerError(e);
		} 
	}
	
	private void createOrderTable() {
		try {
			Statement stmt = conn.createStatement();
			int affectedRows = stmt.executeUpdate(
				"CREATE TABLE IF NOT EXISTS `Order` ("
				+ "id INT AUTO_INCREMENT PRIMARY KEY, "
				+ "`time` VARCHAR(20), `date` VARCHAR(20), "
				+ "employeeId INT, "
				+ "FOREIGN KEY (employeeId) REFERENCES Employee(id) "
				+ "ON DELETE SET NULL );"
			);
			if(affectedRows >= 1)
				System.out.println("Success");
		}
		catch(SQLException e) {
			System.out.println(e.toString());
			throw new ExceptionInInitializerError(e);
		} 
	}
	
	private void createOrderDetailedTable() {
		try {
			Statement stmt = conn.createStatement();
			int affectedRows = stmt.executeUpdate(
				"CREATE TABLE IF NOT EXISTS OrderDetailed ("
				+ "id INT AUTO_INCREMENT PRIMARY KEY, "
				+ "sugar VARCHAR(20), ice VARCHAR(20), "
				+ "productId INT, "
				+ "FOREIGN KEY (productId) REFERENCES Product(id) "
				+ "ON DELETE SET NULL , "
				+ "orderId INT, "
				+ "FOREIGN KEY (orderId) REFERENCES `Order`(id) "
				+ "ON DELETE CASCADE );"
			);
			if(affectedRows >= 1)
				System.out.println("Success");
		}
		catch(SQLException e) {
			System.out.println(e.toString());
			throw new ExceptionInInitializerError(e);
		} 
	}
	
	
	
	private void createSupplierTable() {
		try {
			Statement stmt = conn.createStatement();
			int affectedRows = stmt.executeUpdate(
				"CREATE TABLE IF NOT EXISTS Supplier ("
				+ "id INT AUTO_INCREMENT PRIMARY KEY, "
				+ "name VARCHAR(20), phone VARCHAR(20), address VARCHAR(75));"
			);
			if(affectedRows >= 1)
				System.out.println("Success");
		}
		catch(SQLException e) {
			System.out.println(e.toString());
			throw new ExceptionInInitializerError(e);
		} 
	}
	
	private void createPurchaseTable() {
		try {
			Statement stmt = conn.createStatement();
			int affectedRows = stmt.executeUpdate(
				"CREATE TABLE IF NOT EXISTS Purchase ("
				+ "id INT AUTO_INCREMENT PRIMARY KEY, "
				+ "date VARCHAR(20), "
				+ "employeeId INT, "
				+ "FOREIGN KEY (employeeId) REFERENCES Employee(id) "
				+ "ON DELETE SET NULL );"
			);
			if(affectedRows >= 1)
				System.out.println("Success");
		}
		catch(SQLException e) {
			System.out.println(e.toString());
			throw new ExceptionInInitializerError(e);
		} 
	}
	
	private void createPurchaseDetailedTable() {
		try {
			Statement stmt = conn.createStatement();
			int affectedRows = stmt.executeUpdate(
				"CREATE TABLE IF NOT EXISTS PurchaseDetailed ("
				+ "id INT AUTO_INCREMENT PRIMARY KEY, "
				+ "quantity INT, totalPrice INT, "
				+ "inventoryId INT, "
				+ "FOREIGN KEY (inventoryId) REFERENCES Inventory(id) "
				+ "ON DELETE CASCADE, "
				+ "supplierId INT, "
				+ "FOREIGN KEY (supplierId) REFERENCES Supplier(id) "
				+ "ON DELETE SET NULL, "
				+ "purchaseId INT, "
				+ "FOREIGN KEY (purchaseId) REFERENCES Purchase(id) "
				+ "ON DELETE CASCADE );"
			);
			if(affectedRows >= 1)
				System.out.println("Success");
		}
		catch(SQLException e) {
			System.out.println(e.toString());
			throw new ExceptionInInitializerError(e);
		} 
	}
	
	private void createConsumeTable() {
		try {
			Statement stmt = conn.createStatement();
			int affectedRows = stmt.executeUpdate(
				"CREATE TABLE IF NOT EXISTS Consume ("
				+ "id INT AUTO_INCREMENT PRIMARY KEY, "
				+ "quantity INT, "
				+ "productId INT, "
				+ "FOREIGN KEY (productId) REFERENCES Product(id) "
				+ "ON DELETE CASCADE, "
				+ "inventoryId INT, "
				+ "FOREIGN KEY (inventoryId) REFERENCES Inventory(id) "
				+ "ON DELETE CASCADE );"
			);
			if(affectedRows >= 1)
				System.out.println("Success");
		}
		catch(SQLException e) {
			System.out.println(e.toString());
			throw new ExceptionInInitializerError(e);
		} 
	}

}
