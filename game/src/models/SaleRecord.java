package models;

public class SaleRecord {
	public int id;
	public int quantity;
	public int inventory;
	public String time;
	public int customer;
	public int price;
	
	public SaleRecord(int id, int quantity, int inventory, String time, int customer, int price) {
		this.id = id;
		this.quantity = quantity;
		this.inventory = inventory;
		this.time = time;
		this.customer = customer;
		this.price = price;
		
	}
	
	public SaleRecord(int quantity, int inventory, String time, int customer, int price) {
		this.quantity = quantity;
		this.inventory = inventory;
		this.time = time;
		this.customer = customer;
		this.price = price;
	}
}