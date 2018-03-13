
package models;


public class PurchaseDetailed {
	public int id;
	public int quantity;
	public int totalPrice;
	public Inventory inventory;
	public Supplier supplier;
	public String arrDate;
	
	public PurchaseDetailed(int id, int quantity, int totalPrice, 
			Inventory inventory, Supplier supplier) {
		this.id = id;
		this.quantity = quantity;
		this.totalPrice = totalPrice;
		this.inventory = inventory;
		this.supplier = supplier;
	}
	
	public PurchaseDetailed(int id, int quantity, int totalPrice, 
			Inventory inventory, Supplier supplier, String arrDate) {
		this.id = id;
		this.quantity = quantity;
		this.totalPrice = totalPrice;
		this.inventory = inventory;
		this.supplier = supplier;
		this.arrDate = arrDate;
	}
	
	public PurchaseDetailed(int quantity, int totalPrice, 
			Inventory inventory, Supplier supplier) {
		this.quantity = quantity;
		this.totalPrice = totalPrice;
		this.inventory = inventory;
		this.supplier = supplier;
	}
	
	@Override
	public String toString() {
		return String.format("id: %d, quantity: %d, totalPrice: %d, inventory: %s, supplier: %s", 
				id, quantity, totalPrice, inventory.toString(), supplier.toString());
	}
	
	public boolean equals(PurchaseDetailed p) {
		if(id == p.id)
			return true;
		else
			return false;
	}
}