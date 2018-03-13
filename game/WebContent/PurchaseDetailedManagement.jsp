<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="models.Connector,  models.Inventory, models.InventoryDAO,  
     models.Supplier, models.SupplierDAO,java.sql.Connection, 
    models.PurchaseDetailedDAO, models.PurchaseDetailed, java.util.ArrayList"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>購買管理</title>
<%@ include  file="InHead.html" %>
</head>
<body>
	<%@ include file="Header.html" %>
	<%
	    PurchaseDetailedDAO PurchaseDetailedDAO = new PurchaseDetailedDAO(Connector.getConn());
		request.setCharacterEncoding("UTF-8");
	%>
	
	<!-- DELTE FORM ------------------------------------------------------------------------------------------------>
	
	<%
		String deletedId = request.getParameter("deletedId");
		if(deletedId != null) {
			PurchaseDetailedDAO.delete(PurchaseDetailedDAO.get(Integer.parseInt(deletedId)));
		}
	%>
	
	<!-- INSERT FORM ------------------------------------------------------------------------------------------------>
	
	<h2> 新增存貨 </h2>
	<br />
	<form class="form-inline" action="PurchaseDetailedManagement.jsp" method="POST">
		<div class="form-group">
		   <label for="name">存貨名： </label>
		   <input type="text" class="form-control" id="name" name="name" required> &nbsp;
		</div>
		<div class="form-group">
		   <label for="quantity">存量： </label>
		   <input type="number" class="form-control" id="quantity" name="quantity" required> &nbsp;
		 </div>
		 <div class="form-group">
		   <label for="safetyStock">安全存量：</label>
		   <input type="number" class="form-control" id="safetyStock" name="safetyStock" required> &nbsp;
		 </div>
		 <div class="form-group">
		   <label for="state">平台：</label>
		   <input type="text" class="form-control" id="state" name="state" required> &nbsp;
		 </div>
		 <div class="form-group">
		   <label for="price">售價：</label>
		   <input type="number" class="form-control" id="price" name="price" required> &nbsp;
		 </div>
		 <div class="form-group">
		   <label for="orderTime">進貨需時：</label>
		   <input type="number" class="form-control" id="orderTime" name="orderTime" required> &nbsp;
		 </div>
		
		 <div class="form-group">
		   <input type="submit" value="新增">
		 </div>
	</form>
	
	<% 
		String name = request.getParameter("name");
		String quantityInput = request.getParameter("quantity");
		String safetyStockInput = request.getParameter("safetyStock");
		String state = request.getParameter("state");
		String priceInput = request.getParameter("price");
		String orderTimeInput = request.getParameter("orderTime");
		int quantity = 0, safetyStock = 0, price = 0, orderTime = 0;
		
		
		if(quantityInput != null)
			quantity = Integer.parseInt(quantityInput);
		if(safetyStockInput != null)
			safetyStock = Integer.parseInt(safetyStockInput);
		if(priceInput != null)
			price = Integer.parseInt(priceInput);
		if(orderTimeInput != null)
			orderTime = Integer.parseInt(orderTimeInput);
		
		if(name != null && quantityInput != null && safetyStockInput != null) {
			PurchaseDetailedDAO.insert(new PurchaseDetailed(name, quantity, safetyStock, state, price ,orderTime));
			out.println("新增員工成功");
		} else if(name != null || quantityInput != null || safetyStockInput != null) { 
			out.println("請填入完整的資料");
		} 
	%>
	
	<!-- UPDATE FORM ------------------------------------------------------------------------------------------------>
		<%
		// 表單參數
		String updatedIdfromForm = request.getParameter("updatedIdfromForm");
		String updatedName = request.getParameter("updatedName");
		String updatedQuantity = request.getParameter("updatedQuantity");
		String updatedSafetyStock = request.getParameter("updatedSafetyStock");
		String updatedState = request.getParameter("updatedState");
		String updatedPrice = request.getParameter("updatedPrice");
		String updatedOrderTime = request.getParameter("updatedOrderTime");
		
		
		if(updatedQuantity != null && updatedSafetyStock != null)
			PurchaseDetailedDAO.update(
				new PurchaseDetailed(
					Integer.parseInt(updatedIdfromForm), updatedName, 
					Integer.parseInt(updatedQuantity), Integer.parseInt(updatedSafetyStock),
					updatedState, Integer.parseInt(updatedPrice), Integer.parseInt(updatedPrice)
					
					
				)
			);
		
	    %>
	
	
		<!-- SEARCH FORM ------------------------------------------------------------------------------>
	
	    <hr>
		<h2> 查詢庫存 </h2>
		<br />
		<form class="form-inline" action="InventoryManagement.jsp" method="POST">
		<div class="form-group">
		   <label for="searchName">搜尋名字： </label>
		   <input type="text" class="form-control" id="searchName" name="searchName" required> &nbsp;
		</div>
		       <input type="submit" value="搜尋"> &nbsp;
		       <a href="InventoryManagement.jsp"> 清除 </a>
	   </form>
	   <br />
	   <br />
	 <% 
	 
	 String searchName = request.getParameter("searchName");
	
	 
	 if(searchName != null){
	%>	 
		 <table class="table">
	<tr>
		<th> 存貨編號 </td>
		<td> 存貨名  </td>
		<td> 存量 </td>
		<td> 安全存量 </td>
	</tr>
	<% 
		ArrayList<Inventory> inventorys = inventoryDAO.search(searchName);
		for(Inventory i : inventorys) {
			String trClass = "";
			if(i.quantity < i.safetyStock)
				trClass = "class='table-danger'";
	%>
		<tr <%= trClass %>>
			<td><%= i.id %></td>
			<td><%= i.name %></td>
			<td><%= i.quantity %></td>
			<td><%= i.safetyStock %></td>
			
			<td>
			<a href=<%= "InventoryManagement.jsp?updatedId=" + i.id %>>點我修改</a>
				</td>
				
			<td>
			<a href=<%= "InventoryManagement.jsp?deletedId=" + i.id %>>點我刪除</a>
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
		<th> 存貨編號 </td>
		<td> 存貨名  </td>
		<td> 存量 </td>
		<td> 安全存量 </td>
		<td> 平台 </td>
		<td> 售價 </td>
		<td> 進貨需時 </td>
	</tr>
	<% 
		ArrayList<PurchaseDetailed> PurchaseDetaileds = PurchaseDetailedDAO.getAllPurchaseDetaileds();
		for(PurchaseDetailed i : PurchaseDetaileds) {
			String trClass = "";
			if(i.quantity < i.safetyStock) {
				trClass = "class='bg-danger'";
			}
	%>
		<tr <%= trClass %>>
			<td><%= i.id %></td>
			<td><%= i.name %></td>
			<td><%= i.quantity %></td>
			<td><%= i.safetyStock %></td>
			<td><%= i.state %></td>
			<td><%= i.price %></td>
			<td><%= i.orderTime %></td>
			
			<td>
			<a href=<%= "PurchaseDetailedManagement.jsp?updatedId=" + i.id %>>點我修改</a>
				</td>
				
			<td>
			<a href=<%= "PurchaseDetailedManagement.jsp?deletedId=" + i.id %>>點我刪除</a>
				</td>
		</tr>
	<%
		} 
	%>
	</table>
	
	
	
	<%	
	   }
		// 網址參數
		
		String updatedId = request.getParameter("updatedId");
		
		if(updatedId != null && updatedIdfromForm == null) {
			int id = Integer.parseInt(updatedId);
			PurchaseDetailed i = PurchaseDetailedDAO.get(id);
	%>
			<hr>
			<h3> 修改存貨 </h3>
			<form class="form-inline" action="PurchaseDetailedManagement.jsp" method="POST">
				<div class="form-group">
					<label>存貨編號：<e><%= i.id %></e> &nbsp;</label>
					<input type="number" name="updatedIdfromForm" value=<%= i.id %>
					style="display: None;">
				</div>
				<div class="form-group">
				   <label for="updatedName">存貨名：</label> 
				   <input type="text" class="form-control" value=<%= i.name %>
				   id="updatedName" name="updatedName" required> &nbsp;
				</div>
				<div class="form-group">
				   <label for="updatedQuantity">存量： </label>
				   <input type="number" class="form-control" value=<%= i.quantity %>
				   id="updatedQuantity" name="updatedQuantity" required> &nbsp;
				 </div>
				 <div class="form-group">
				   <label for="updatedSafetyStock">安全存量：</label>
				   <input type="number" class="form-control" value=<%= i.safetyStock %>
				   id="updatedSafetyStock" name="updatedSafetyStock" required> &nbsp;
				 </div>
				 <div class="form-group">
				   <label for="updatedState">平台：</label>
				   <input type="text" class="form-control" value=<%= i.state %>
				   id="updatedState" name="updatedState" required> &nbsp;
				 </div>
				 <div class="form-group">
				   <label for="updatedPrice">售價：</label>
				   <input type="number" class="form-control" value=<%= i.price %>
				   id="updatedPrice" name="updatedPrice" required> &nbsp;
				 </div>
				 <div class="form-group">
				   <label for="updatedOrderTime">進貨需時：</label>
				   <input type="number" class="form-control" value=<%= i.orderTime %>
				   id="updatedOrderTime" name="updatedOrderTime" required> &nbsp;
				 </div>
				 <div class="form-group">
				   <input type="submit" value="確認修改">
				 </div>
			</form>
	<%
		}
	%>
		<br />
		<br />
		<br />
</body>
</html>