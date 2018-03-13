package models;
public class Inventory {
	public int id;
	public String name;
	public int quantity;
	public String state;
	public int price;
	public int orderTime;
	public int safetyStock;
	public float cost;
	public int shipping;
	
	public Inventory(int id, String name, int quantity, int safetyStock, String state, int price, int orderTime, float cost, int shipping) {
		this.id = id;
		this.name = name;
		this.quantity = quantity;
		this.safetyStock = safetyStock;
		this.state = state;
		this.price = price;
		this.orderTime = orderTime;	
		this.cost = cost;
		this.shipping = shipping;
	}
	
	public Inventory(int id, String name, int quantity, int safetyStock, String state, int price, int orderTime, float cost) {
		this.id = id;
		this.name = name;
		this.quantity = quantity;
		this.safetyStock = safetyStock;
		this.state = state;
		this.price = price;
		this.orderTime = orderTime;	
		this.cost = cost;
	}
	
	public Inventory(int id, String name, int quantity, int safetyStock, String state, int price, int orderTime) {
		this.id = id;
		this.name = name;
		this.quantity = quantity;
		this.safetyStock = safetyStock;
		this.state = state;
		this.price = price;
		this.orderTime = orderTime;	
		
	}
	
	public Inventory(String name, int quantity, int safetyStock, String state, int price, int orderTime) {
		this.name = name;
		this.quantity = quantity;
		this.safetyStock = safetyStock;
		this.state = state;
		this.price = price;
		this.orderTime = orderTime;		
	}
	
	public Inventory(String name, int quantity, int safetyStock, String state, int price, int orderTime,float cost) {
		this.name = name;
		this.quantity = quantity;
		this.safetyStock = safetyStock;
		this.state = state;
		this.price = price;
		this.orderTime = orderTime;
		this.cost = cost;
	}
	
	@Override
	public String toString() {
		return String.format("id: %d, name: %s, quantity: %d, safetyStock: %d, state: %s, price: %d,orderTime: %d", 
				id, name, quantity, safetyStock,state, price ,orderTime);
	}
}
