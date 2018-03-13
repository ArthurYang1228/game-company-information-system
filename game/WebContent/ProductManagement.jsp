<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Connector, models.Product, models.ProductDAO, java.util.ArrayList"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>產品管理</title>
<%@ include  file="InHead.html" %>
</head>
<body>
	<%@ include file="Header.html" %>
	<%
		ProductDAO productDAO = new ProductDAO(Connector.getConn());
		request.setCharacterEncoding("UTF-8");
	%>
	
	<!-- DELTE FORM ------------------------------------------------------------------------------------------------>
	
	<%
		String deletedId = request.getParameter("deletedId");
		String updatedIfromForm = request.getParameter("updatedIfromForm");
		String updatedName = request.getParameter("updatedName");
		String updatedSize = request.getParameter("updatedSize");
		String updatedPrice = request.getParameter("updatedPrice");
		if(deletedId != null) {
			productDAO.delete(productDAO.getProduct(Integer.parseInt(deletedId)));
		}
		
		// 表單參數
		if(updatedIfromForm != null && updatedPrice != null)
			productDAO.update(
				new Product(
					Integer.parseInt(updatedIfromForm), updatedName, updatedSize, 
					Integer.parseInt(updatedPrice)
				)
			);
		
	%>
	
	
	
	
	<!-- INSERT FORM ------------------------------------------------------------------------------------------------>
	
	<h2> 新增產品 </h2>
	<br />
	<form class="form-inline" action="ProductManagement.jsp" method="POST">
		<div class="form-group">
		   <label for="name">品名：</label>
		   <input type="text" class="form-control" id="name" name="name" required> &nbsp;
		</div>
		容量： <select class="form-control" name="size">
　              <option value="大">大</option>
　             <option value="中">中</option>
       </select>
		價格： <input type="number" name="price"required>
		<input type="submit" value="新增">
	</form>
	
	<% 
		String name = request.getParameter("name");
		String size = request.getParameter("size");
		String priceInput = request.getParameter("price");
		int price = 0;
		
		if(priceInput != null)
			price = Integer.parseInt(priceInput);
			
		if(name != null && size != null && priceInput != null) {
			productDAO.insert(new Product(name, size, price));
			out.println("新增產品成功");
		} 
		
		
		
	%>
	
	<!-- SEARCH FORM ------------------------------------------------------------------------------>
	
	   <hr>
		<h2> 查詢產品 </h2>
		<br />
	   <form class="form-inline" action="ProductManagement.jsp" method="POST">
		<div class="form-group">
		   <label for="searchName">品名：</label>
		   <input type="text" class="form-control" id="searchName" name="searchName" required> &nbsp;
		</div>
		       <input type="submit" value="搜尋"> &nbsp;
		       <a href="ProductManagement.jsp"> 清除 </a>
	   </form>
	   <br />
	   <br />
	 <% 
	 
	 String searchName = request.getParameter("searchName");
	 if(searchName != null){
	%>	 
		 <table class="table">
			<tr>
				<th> 產品編號 </td>
			<td> 品名  </td>
			<td> 容量 </td>
			<td colspan="3"> 價格 </td>
				
			</tr>
			<% 
				ArrayList<Product> products= productDAO.search(searchName);
				for(Product p : products) {
			%>
				<tr>
					<td><%= p.id %></td>
					<td><%= p.name %></td>
					<td><%= p.size %></td>
				<td><%= p.price %></td>
					<td>
						<a href=<%= "ProductManagement.jsp?updatedId=" + p.id %>>
							點我修改
						</a>
					</td>
					<td>
						<a href=<%= "ProductManagement.jsp?deletedId=" + p.id %>>
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
			<th> 產品編號 </td>
			<td> 品名  </td>
			<td> 容量 </td>
			<td colspan="3"> 價格 </td>
			
		</tr>
		<% 
			ArrayList<Product> products = productDAO.getAllProducts();
			for(Product p : products) {
		%>
			<tr>
				<td><%= p.id %></td>
				<td><%= p.name %></td>
				<td><%= p.size %></td>
				<td><%= p.price %></td>
				<td>
					<a href=<%= "ProductManagement.jsp?updatedId=" + p.id %>>
						點我修改
					</a>
				</td>
				<td>
					<a href=<%= "ProductManagement.jsp?deletedId=" + p.id %>>
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
			Product p = productDAO.getProduct(id);
	%>
			<hr>
			<h3> 修改員工 </h3>
			<form class="form-inline" action="ProductManagement.jsp" method="POST">
				<div class="form-group">
					<label>產品編號：<e><%= p.id %></e> &nbsp;</label>
					<input type="number" name="updatedIfromForm" value=<%= p.id %>
					style="display: None;">
				</div>
				<div class="form-group">
				   <label for="updatedName">品名：</label> 
				   <input type="text" class="form-control" value=<%= p.name %>
				   id="updatedName" name="updatedName" required> &nbsp;
				</div>
				容量： 
				<select class="form-control" name="updatedSize" value="<%= p.size %>">
					<option value="大">大</option>
		　             		<option value="中">中</option>
		      	</select>
				 <div class="form-group">
				 	<label for="updatedPrice">價格： </label> 
				   <input type="number" class="form-control" value=<%= p.price %>
				   id="updatedPrice" name="updatedPrice" required> &nbsp;
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