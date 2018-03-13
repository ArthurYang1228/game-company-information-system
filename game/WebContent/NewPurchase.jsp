<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.*, java.sql.*, java.util.Enumeration, java.util.ArrayList, 
			java.util.Date, java.text.SimpleDateFormat, java.text.DateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新增進貨</title>
<script type="text/javascript" language="javascript">
	function onSelected(beforeInventorys) {
		if(beforeInventorys == "0") {
			toUrl = "/game/NewPurchase.jsp?inventorys=" + document.getElementById("inventoryID").value + "-" + 
				document.getElementById("quantity").value + "-" + document.getElementById("totalPrice").value 
				+ "-" + document.getElementById("supplier").value + ",";
		}
		else {
			toUrl = "/game/NewPurchase.jsp?inventorys=" + beforeInventorys + document.getElementById("inventoryID").value + "-" + 
			document.getElementById("quantity").value + "-"
			+ document.getElementById("totalPrice").value + "-" + document.getElementById("supplier").value + ",";
		}
		window.location.replace(toUrl);
	}
</script>
<%@ include  file="InHead.html" %>
</head>
<body>
	<%@ include file="Header.html" %>
    <%
    request.setCharacterEncoding("UTF-8");
    Connection conn = Connector.getConn();
    Statement stmt = conn.createStatement();
    
    ResultSet rs1 = stmt.executeQuery("SELECT DATEDIFF(NOW(), date) AS DiffDate FROM turnover WHERE id=1");
    if (rs1.next() && rs1.getInt("DiffDate")>30){
    	turnover t = new turnover();
    	t.getTurnover();
    	SafeQuantity s = new SafeQuantity(conn);
    	s.Compute();
    	PrepareTime p = new PrepareTime(conn);
    	p.Compute();
    	predict pr = new predict(conn);
    	for(int id : pr.getAllID()){
    		pr.setSalePerDay(id);
    	}
    	
    }
    	
    
    ResultSet rs = stmt.executeQuery(
    		"SELECT * FROM turnover"
    	);

    	if(rs.next()){
    		float t = rs.getFloat("turnover");
    		out.print("<h3>存貨周轉率:"+ t +"  週轉天數:"+ 30/t +"</h3>");
    	}
    	rs.close();
    
    
    String sql = "SELECT * FROM inventory";
    ResultSet rst=stmt.executeQuery(sql);
    out.println("<h3>急需進貨:</h3>");
    
    while(rst.next()){
  		int a = rst.getInt("quantity");
  		int b = rst.getInt("salesPerDay");
  		int c = rst.getInt("orderTime");
  		int d = rst.getInt("repurchaseQuantity");
  		int e = rst.getInt("shippingQuantity");
  		int f = a+e-(b*c);
  		if(f <= d){
  				String name = rst.getString("name")+"("+rst.getString("state")+")";
  				String number = rst.getString("economicQuantity");
  				out.println(" <h3>存貨:"+name +"</h3></br>" );
  		}
    }
  	rst.close();
  	stmt.close();
		
		
		
    
    PurchaseDAO purchaseDAO = new PurchaseDAO(conn);
	
    PurchaseDetailedDAO purchaseDetailedDAO = new PurchaseDetailedDAO(conn);
	InventoryDAO inventoryDAO = new InventoryDAO(conn);
	SupplierDAO supplierDAO = new SupplierDAO(conn);
	%>
	<%
		String inventorysInput = request.getParameter("inventorys");
	    String beforeInventorys;
		if(inventorysInput == null) {
			beforeInventorys = "0";
		} else {
			beforeInventorys = inventorysInput;
		}
	%>
	
	
	<form action="javascript:onSelected('<%= beforeInventorys %>')">
	
			存貨：
			<select id="inventoryID">
	<%
			for(Inventory i : inventoryDAO.getAllInventorys()) {
	%>
				<option value=<%=i.id %>><%=i.name + "(" + i.state + ")"  %></option>
	<%
			}
	%>
			</select>
		
		        數量:<input type="number" id="quantity" min="1" required>
		        總價:<input type="number" id="totalPrice" min="1" required> 
		
		
			供應商：<select id="supplier"> 
	<%
			for(Supplier s : supplierDAO.getAllSuppliers()) {
				
	%>
				<option value=<%=s.id %>><%=s.name  %></option>
	<%
			}
	%>
			</select>
			<input type="submit" value="新增">
	</form>
	
	<hr>
	
	<% 
		
		if(inventorysInput != null) {
			String[] inventoryInfos = inventorysInput.split(",");
			for(String inventoryInfo: inventoryInfos) {
				String[] iInfo = inventoryInfo.split("-");
				int inventoryId = Integer.parseInt(iInfo[0]);
				int quantity = Integer.parseInt(iInfo[1]);
				int totalPrice = Integer.parseInt(iInfo[2]);
				int supplierId = Integer.parseInt(iInfo[3]);
				Inventory i = inventoryDAO.getInventory(inventoryId);
				Supplier s = supplierDAO.getSupplier(supplierId);
	%>
				<p><%= i.name + " " + quantity + " " + totalPrice + " " + s.name %></p>
	<%
			}
		}
	%>
	
	
	
	<form action="NewPurchase.jsp" method="POST">
		<input type="text" name="postInventorysInput" value=<%= inventorysInput %> 
		style="display: None"></input>
		
	<%
			if(inventorysInput !=null){
	%>		
		<input type="submit" value="確認訂貨"> <a href="NewPurchase.jsp"> 全部刪除 </a>
	<%
			}
	%>
	</form>
	
	<%	
		String postInventorysInput = request.getParameter("postInventorysInput");
		
	
		if(postInventorysInput != null ) {
			String[] postInventory = postInventorysInput.split(",");
			
			Date date = new Date();
			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			
			
			Purchase purchase = new Purchase(dateFormat.format(date));
			for(String s: postInventory) {
				
				String[] s2 = s.split("-");
				int inventoryId = Integer.parseInt(s2[0]);
				
				int quantity = Integer.parseInt(s2[1]);
				int totalPrice = Integer.parseInt(s2[2]);
				int supplierId = Integer.parseInt(s2[3]);
				Inventory inventory = inventoryDAO.getInventory(inventoryId);
				inventory.shipping += quantity;
				inventoryDAO.update(inventory);
				purchase.addPurchaseDetailed(
					new PurchaseDetailed(quantity, totalPrice,
					inventory, supplierDAO.getSupplier(supplierId)));
				
			
				
				turnover t = new turnover();
				t.setEnd(totalPrice,1 );
			}
			purchaseDAO.insert(purchase);
			
			SafeQuantity s = new SafeQuantity(conn);
			s.Compute();
			out.print("新增成功");
		}
	%>
</body>
</html>
