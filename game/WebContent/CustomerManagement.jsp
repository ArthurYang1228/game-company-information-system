<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="models.Connector, models.Customer, models.CustomerDAO, java.util.ArrayList" %>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>顧客管理</title>
<%@ include  file="InHead.html" %>
</head>
<body>
	<%@ include  file="Header.html" %>
	<%
		request.setCharacterEncoding("UTF-8");
		CustomerDAO customerDAO = new CustomerDAO(Connector.getConn());
	%>
	<!-- DELTE FORM ------------------------------------------------------------------------------------------------>
	
	<%
		String deletedId = request.getParameter("deletedId");
		if(deletedId != null) {
			customerDAO.delete(customerDAO.getCustomer(Integer.parseInt(deletedId)));
		}
	%>
	
	<%
		// 表單參數
		String updatedIfromForm = request.getParameter("updatedIfromForm");
		String updatedName = request.getParameter("updatedName");
		String updatedPhone = request.getParameter("updatedPhone");
		String updatedAddress = request.getParameter("updatedAddress");
		String updatedBirthdate = request.getParameter("updatedBirthdate");
		String updatedGender = request.getParameter("updatedGender");
		
		if(updatedIfromForm != null && updatedName != null)
			customerDAO.update(
				new Customer(
					Integer.parseInt(updatedIfromForm), updatedName, updatedPhone, 
					updatedAddress, updatedBirthdate, Integer.parseInt(updatedGender)
				)
			);
		
	%>
	
	<!-- INSERT FORM ------------------------------------------------------------------------------------------------>
	
	<h2> 新增會員 </h2>
	<br />
	<form class="form-inline" action="CustomerManagement.jsp" method="POST">
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
		   <label for="gender">性別： </label>
		   <input type="radio" value="1" class="form-control" id="male" name="gender" required> &nbsp;
		   <label for="male"> 男性</label>
		   <input type="radio" value="0" class="form-control" id="female" name="gender" required>
		   <label for="female"> 女性</label>
		 </div>
		 <div class="form-group">
		   <label for="birthdate">生日： </label>
		   <input type="date" class="form-control" id="birthdate" name="birthdate" required> &nbsp;  
		   生日格式請用 YYYY/MM/DD          
		 </div>
		 <div class="form-group">
		   <input type="submit" value="新增">
		 </div>
	</form>
	
	<% 
		String name = request.getParameter("name");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");
		String birthdate = request.getParameter("birthdate");
		String gender = request.getParameter("gender");
		if(name != null && phone != null && address != null && request.getParameter("gender")!=null && birthdate != null ) {
			customerDAO.insert(new Customer(name, phone, address, birthdate, Integer.parseInt(gender)));
			out.println("新增會員成功");
		}
	%>
	
	<!-- SEARCH FORM ------------------------------------------------------------------------------>
	
	 <hr>
		<h2> 查詢會員 </h2>
		<br />
	   <form class="form-inline" action="CustomerManagement.jsp" method="POST">
		<div class="form-group">
		   <label for="searchName">搜尋名字： </label>
		   <input type="text" class="form-control" id="searchName" name="searchName" required> &nbsp;
		</div>
		       <input type="submit" value="搜尋"> &nbsp;
		       <a href="CustomerManagement.jsp"> 清除 </a>
	   </form>
	   <br />
	   <br />
	   
	 <%
	 String searchName = request.getParameter("searchName");
	 if(searchName != null){
	%>	 
		 <table class="table">
			<tr>
				<td> 會員編號 </td>
				<td> 名字  </td>
				<td> 電話 </td>
				<td> 地址 </td>
				<td> 生日</td>
				<td> 性別</td>
				
			</tr>
			<% 
				ArrayList<Customer> customers = customerDAO.search(searchName);
				for(Customer s : customers) {
			%>
				<tr>
					<td><%= s.id %></td>
					<td><%= s.name %></td>
					<td><%= s.phone %></td>
					<td><%= s.address %></td>
					<td><%= s.birthdate%></td>
					<td><%= s.gender %></td>
					<td>
						<a href=<%= "CustomerManagement.jsp?updatedId=" + s.id %>>
							點我修改
						</a>
					</td>
					<td>
						<a href=<%= "CustomerManagement.jsp?deletedId=" + s.id %>>
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
			<td> 會員編號 </td>
			<td> 名字  </td>
			<td> 電話 </td>
			<td> 地址 </td>
			<td> 生日</td>
			<td> 性別</td>
			
		</tr>
		<% 
			ArrayList<Customer> customers = customerDAO.getAllCustomers();
			for(Customer s : customers) {
		%>
			<tr>
				<td><%= s.id %></td>
				<td><%= s.name %></td>
				<td><%= s.phone %></td>
				<td><%= s.address %></td>
				<td><%= s.birthdate%></td>
				<td><%= s.gender %></td>
				<td>
					<a href=<%= "CustomerManagement.jsp?updatedId=" + s.id %>>
						點我修改
					</a>
				</td>
				<td>
					<a href=<%= "CustomerManagement.jsp?deletedId=" + s.id %>>
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
			Customer s = customerDAO.getCustomer(id);
	%>
			<hr>
			<h3> 修改會員資料 </h3>
			<form class="form-inline" action="CustomerManagement.jsp" method="POST">
				<div class="form-group">
					<label>會員編號：<e><%= s.id %></e> &nbsp;</label>
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
				   <label for="updatedBirthdate">生日： </label>
				   <input type="text" class="form-control" value=<%= s.birthdate %>
				   id="updatedBirthdate" name="updatedBirthdate" required> &nbsp;
				 </div>
				 <div class="form-group">
				   <label for="updatedGender">性別： </label>
				   <input type="text" class="form-control" value=<%= s.gender %>
				   id="updatedGender" name="updatedGender" required> &nbsp;
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