<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Connector, models.Supplier, models.SupplierDAO, java.util.ArrayList"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>供應商管理</title>
<%@ include  file="InHead.html" %>
</head>
<body>
	<%@ include  file="Header.html" %>
	<%
		request.setCharacterEncoding("UTF-8");
		SupplierDAO supplierDAO = new SupplierDAO(Connector.getConn());
	%>
	
	<!-- DELTE FORM ------------------------------------------------------------------------------------------------>
	
	<%
		String deletedId = request.getParameter("deletedId");
		if(deletedId != null) {
			supplierDAO.delete(supplierDAO.getSupplier(Integer.parseInt(deletedId)));
		}
	%>
	
	<%
		// 表單參數
		String updatedIfromForm = request.getParameter("updatedIfromForm");
		String updatedName = request.getParameter("updatedName");
		String updatedPhone = request.getParameter("updatedPhone");
		String updatedAddress = request.getParameter("updatedAddress");
		
		if(updatedIfromForm != null && updatedName != null)
			supplierDAO.update(
				new Supplier(
					Integer.parseInt(updatedIfromForm), updatedName, updatedPhone, updatedAddress
				)
			);
		
	%>
	
	<!-- INSERT FORM ------------------------------------------------------------------------------------------------>
	
	<h2> 新增廠商 </h2>
	<br />
	<form class="form-inline" action="SupplierManagement.jsp" method="POST">
		<div class="form-group">
		   <label for="name">名字： </label>
		   <input type="text" class="form-control" id="name" name="name" required> &nbsp;
		</div>
		<div class="form-group">
		   <label for="phone">電話： </label>
		   <input type="text" class="form-control" id="phone" name="phone" required> &nbsp;
		 </div>
		 <div class="form-group">
		   <label for="address">地址： </label>
		   <input type="text" class="form-control" id="address" name="address" required> &nbsp;
		 </div>
		 <div class="form-group">
		   <input type="submit" value="新增">
		 </div>
	</form>
	
	<% 
		String name = request.getParameter("name");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");
		
		
		if(name != null && phone != null && address != null) {
			supplierDAO.insert(new Supplier(name, phone, address));
			out.println("新增廠商成功");
		}
	%>
	
	<!-- SEARCH FORM ------------------------------------------------------------------------------>
	
	 <hr>
		<h2> 查詢廠商 </h2>
		<br />
	   <form class="form-inline" action="SupplierManagement.jsp" method="POST">
		<div class="form-group">
		   <label for="searchName">搜尋名字： </label>
		   <input type="text" class="form-control" id="searchName" name="searchName" required> &nbsp;
		</div>
		       <input type="submit" value="搜尋"> &nbsp;
		       <a href="SupplierManagement.jsp"> 清除 </a>
	   </form>
	   <br />
	   <br />
	   
	 <%
	 String searchName = request.getParameter("searchName");
	 if(searchName != null){
	%>	 
		 <table class="table">
			<tr>
				<th> 廠商編號 </td>
				<td> 名字  </td>
				<td> 電話 </td>
				<td> 地址 </td>
				
			</tr>
			<% 
				ArrayList<Supplier> supplies = supplierDAO.search(searchName);
				for(Supplier s : supplies) {
			%>
				<tr>
					<td><%= s.id %></td>
					<td><%= s.name %></td>
					<td><%= s.phone %></td>
					<td><%= s.address %></td>
					<td>
						<a href=<%= "SupplierManagement.jsp?updatedId=" + s.id %>>
							點我修改
						</a>
					</td>
					<td>
						<a href=<%= "SupplierManagement.jsp?deletedId=" + s.id %>>
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
			<th> 廠商編號 </td>
			<td> 名字  </td>
			<td> 電話 </td>
			<td> 地址 </td>
			
		</tr>
		<% 
			ArrayList<Supplier> suppliers = supplierDAO.getAllSuppliers();
			for(Supplier s : suppliers) {
		%>
			<tr>
				<td><%= s.id %></td>
				<td><%= s.name %></td>
				<td><%= s.phone %></td>
				<td><%= s.address %></td>
				<td>
					<a href=<%= "SupplierManagement.jsp?updatedId=" + s.id %>>
						點我修改
					</a>
				</td>
				<td>
					<a href=<%= "SupplierManagement.jsp?deletedId=" + s.id %>>
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
	
	<%	
		// 網址參數
		String updatedId = request.getParameter("updatedId");
		
		if(updatedId != null && updatedIfromForm == null) {
			int id = Integer.parseInt(updatedId);
			Supplier s = supplierDAO.getSupplier(id);
	%>
			<hr>
			<h3> 修改廠商 </h3>
			<form class="form-inline" action="SupplierManagement.jsp" method="POST">
				<div class="form-group">
					<label>廠商編號：<e><%= s.id %></e> &nbsp;</label>
					<input type="number" name="updatedIfromForm" value=<%= s.id %>
					style="display: None;">
				</div>
				<div class="form-group">
				   <label for="updatedName">名字： </label> 
				   <input type="text" class="form-control" value=<%= s.name %>
				   id="updatedName" name="updatedName" required> &nbsp;
				</div>
				<div class="form-group">
				   <label for="updatedWorkingHours">電話： </label>
				   <input type="text" class="form-control" value=<%= s.phone %>
				   id="updatedPhone" name="updatedPhone" required> &nbsp;
				 </div>
				 <div class="form-group">
				   <label for="updatedAddress">地址： </label>
				   <input type="text" class="form-control" value=<%= s.address %>
				   id="updatedAddress" name="updatedAddress" required> &nbsp;
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
