package models;

public class Supplier {
	public int id;
	public String name;
	public String phone;
	public String address;
	
	public Supplier(int id, String name, String phone, String address) {
		this.id = id;
		this.name = name;
		this.phone = phone;
		this.address = address;
	}
	
	public Supplier(String name, String phone, String address) {
		this.name = name;
		this.phone = phone;
		this.address = address;
	}
	
	@Override
	public String toString() {
		return String.format("id: %d, name: %s, phone: %s, address: %s", 
				id, name, phone, address);
	}
}
