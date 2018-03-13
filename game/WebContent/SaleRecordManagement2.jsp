<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="models.Connector, models.SaleRecord, models.SaleRecordDAO, 
				 models.Customer, models.CustomerDAO, java.util.ArrayList,
				 models.Inventory, models.InventoryDAO, models.turnover,
				java.util.Date, java.text.SimpleDateFormat, java.text.DateFormat" %>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>銷售紀錄管理</title>
<%@ include  file="InHead.html" %>
</head>
<body>
	<%@ include  file="Header.html" %>
	<%
		request.setCharacterEncoding("UTF-8");
		SaleRecordDAO saleRecordDAO = new SaleRecordDAO(Connector.getConn());
		CustomerDAO customerDAO =new CustomerDAO(Connector.getConn());
		InventoryDAO inventoryDAO = new InventoryDAO(Connector.getConn());
		
	%>
	<!-- DELTE FORM ------------------------------------------------------------------------------------------------>
	
	<%
		String deletedId = request.getParameter("deletedId");
		if(deletedId != null) {
			Inventory temp =  inventoryDAO.getInventory(saleRecordDAO.getSaleRecord(Integer.parseInt(deletedId)).inventory);//用來抓目標商品，再用內建的update方法更新存量
			inventoryDAO.update(new Inventory(temp.id, temp.name, temp.quantity+saleRecordDAO.getSaleRecord(Integer.parseInt(deletedId)).quantity, temp.safetyStock, temp.state, temp.price, temp.orderTime));
			saleRecordDAO.delete(saleRecordDAO.getSaleRecord(Integer.parseInt(deletedId)));
		}
	%>
	
	<%
		// 表單參數
//		String updatedIfromForm = request.getParameter("updatedIfromForm");
//		String updatedName = request.getParameter("updatedName");
//		String updatedPhone = request.getParameter("updatedPhone");
//		String updatedAddress = request.getParameter("updatedAddress");
//		String updatedBirthdate = request.getParameter("updatedBirthdate");
//		String updatedGender = request.getParameter("updatedGender");
//		
//		if(updatedIfromForm != null && updatedName != null)
//			saleRecordDAO.update(
//				new SaleRecord(
//					Integer.parseInt(updatedIfromForm), updatedName, updatedPhone, 
//					updatedAddress, updatedBirthdate, Integer.parseInt(updatedGender)
//				)
//			);
		
	%>
	
	<!-- INSERT FORM ------------------------------------------------------------------------------------------------>
	
	<h2> 新增銷售資料 </h2>
	<br />
	<form class="form-inline" action="SaleRecordManagement2.jsp" method="POST">
		<div class="form-group">
		   <label for="customer">會員： </label>
			<select class="form-control" id="customer" name="customer" required>
			<%
					for(Customer c : customerDAO.getAllCustomers()) {
			%>
						<option value=<%=c.id %>><%=c.id+"  "+c.name %></option>
			<%
					}
			%>
			</select> &nbsp;
		</div>
		<div class="form-group">
		   <label for="inventory">商品： </label>
			<select class="form-control" id="inventory" name="inventory" required>
			<%
					for(Inventory i : inventoryDAO.getAllInventorys()) {
			%>
						<option value=<%=i.id %>><%="  "+i.name+" ( "+i.state+" ) ,單價:"+ i.price %></option>
			<%
					}
			%>
			</select> &nbsp;
		</div>
		<div class="form-group">
		   <label for="quantity">數量： </label>
		   <input type="number" class="form-control" id="quantity" name="quantity" required> &nbsp;
		</div>
		 <div class="form-group">
		   <input type="submit" value="新增">
		 </div>
	</form>
	
	<% 
		String customer = request.getParameter("customer");
		String inventory = request.getParameter("inventory");
		String quantity = request.getParameter("quantity");
		
		Date date = new Date();
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		String dateString = dateFormat.format(date);
		
		if(customer != null && inventory != null && quantity != null && inventoryDAO.getInventory(Integer.parseInt(inventory)).quantity >= Integer.parseInt(quantity) && Integer.parseInt(quantity) > 0) {
			Inventory temp = inventoryDAO.getInventory(Integer.parseInt(inventory));  //用來抓目標商品，再用內建的update方法更新存量
			
			saleRecordDAO.insert(new SaleRecord(Integer.parseInt(quantity), Integer.parseInt(inventory), dateString.toString(), Integer.parseInt(customer), temp.price*Integer.parseInt(quantity)));
			inventoryDAO.update(new Inventory(temp.id, temp.name, temp.quantity-Integer.parseInt(quantity), temp.safetyStock, temp.state, temp.price, temp.orderTime));
			turnover t = new turnover();
			t.setCost(temp.cost, Integer.parseInt(quantity));
			t.setEnd(-temp.cost, Integer.parseInt(quantity));
			out.println("新增銷售紀錄成功");
		}
		else{
		if(customer != null && inventory != null && quantity != null && inventoryDAO.getInventory(Integer.parseInt(inventory)).quantity < Integer.parseInt(quantity)){
			out.println("該商品存貨數量不足，請檢察輸入內容");			
			}
		}
	%>
	
	<!-- SEARCH FORM ------------------------------------------------------------------------------>
 	
	 <hr>
		<h2> 查詢銷售資料 </h2>
		<br />
	   <form class="form-inline" action="SaleRecordManagement2.jsp" method="POST">
		<div class="form-group">
		   <label for="searchName">搜尋編號： </label>
		   <input type="number" class="form-control" id="searchName" name="searchName" required> &nbsp;
		</div>
		       <input type="submit" value="搜尋"> &nbsp;
		       <a href="SaleRecordManagement2.jsp"> 清除 </a>
	   </form>
	   <br />
	   <br />
	   
	 <%
	 String searchName = request.getParameter("searchName");
	 if(searchName != null){
	%>	 
		 <table class="table">
			<tr>
				<td> 銷售編號 </td>
				<td> 數量  </td>
				<td> 商品</td>
				<td> 時間 </td>
				<td> 顧客</td>
				<td> 金額</td>
				
			</tr>
			<% 
				int search = Integer.parseInt(searchName);
				ArrayList<SaleRecord> saleRecords = saleRecordDAO.search(search);
				Inventory tempInv = null;
				Customer tempCus = null;
				for(SaleRecord s : saleRecords) {
					tempInv = inventoryDAO.getInventory(s.inventory);
					tempCus = customerDAO.getCustomer(s.customer);
			%>
				<tr>
					<td><%= s.id %></td>
					<td><%= s.quantity %></td>
					<td><%= s.inventory+"&nbsp&nbsp"+tempInv.name+" ( "+tempInv.state+" ) "%></td>
					<td><%= s.time %></td>
					<td><%= s.customer+"&nbsp&nbsp"+tempCus.name%></td>
					<td><%= s.price %></td>
					<td>
						<a href=<%= "SaleRecordManagement2.jsp?deletedId=" + s.id %>>
							點我刪除
						</a>
					</td>
					
					
				</tr>
				
			<% 
				} 
			%>
			</table>
	
	<%
	 }
	
	// SHOW DATA ------------------------------------------------------------------------------------------------>
	   else{ 
	%>
	<table class="table">
		<tr>
			<td> 銷售編號 </td>
			<td> 數量  </td>
			<td> 商品</td>
			<td> 時間 </td>
			<td> 顧客</td>
			<td> 價格</td>
			
		</tr>
		<% 
			ArrayList<SaleRecord> saleRecords = saleRecordDAO.getAllSaleRecords();
			Inventory tempInv = null;
			Customer tempCus = null;
			for(SaleRecord s : saleRecords) {
				tempInv = inventoryDAO.getInventory(s.inventory);
				tempCus = customerDAO.getCustomer(s.customer);
		%>
			<tr>
				<td><%= s.id %></td>
				<td><%= s.quantity %></td>
				<td><%= s.inventory+"&nbsp&nbsp&nbsp"+tempInv.name+" ( "+tempInv.state+" ) " %></td>
				<td><%= s.time %></td>
				<td><%= s.customer+"&nbsp&nbsp&nbsp"+tempCus.name%></td>
				<td><%= s.price %></td>
				<td>
					<a href=<%= "SaleRecordManagement2.jsp?deletedId=" + s.id %>>
						點我刪除
					</a>
				</td>
				
				
			</tr>
			
		<% 
			} 
		%>
	</table>
	
	<%
	   }
	%>
	
	<!-- UPDATE FORM ------------------------------------------------------------------------------------------------>

</body>
</html>