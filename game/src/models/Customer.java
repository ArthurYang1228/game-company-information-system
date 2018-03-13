package models;

public class Customer {
	public int id;
	public String name;
	public String phone;
	public String address;
	public String birthdate;
	public int gender;
	
	public Customer(int id, String name, String phone, String address, String birthdate, int gender) {
		this.id = id;
		this.name = name;
		this.phone = phone;
		this.address = address;
		this.birthdate = birthdate;
		this.gender = gender;
	}
	
	public Customer(String name, String phone, String address, String birthdate, int gender) {
		this.name = name;
		this.phone = phone;
		this.address = address;
		this.birthdate = birthdate;
		this.gender = gender;
	}
	
	@Override
	public String toString() {
		return String.format("id: %d, name: %s, phone: %s, address: %s, birthdate: %s, gender: %d", 
				id, name, phone, address, birthdate, gender);
	}
}
