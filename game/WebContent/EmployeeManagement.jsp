<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Connector, models.Employee, models.EmployeeDAO, java.util.ArrayList"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>員工管理</title>
<%@ include  file="InHead.html" %>
</head>
<body>
	<%@ include file="Header.html" %>
	<%
		request.setCharacterEncoding("UTF-8");
		EmployeeDAO employeeDAO = new EmployeeDAO(Connector.getConn());
	%>
	
	<!-- DELTE FORM ------------------------------------------------------------------------------------------------>
	
	<%
		String deletedId = request.getParameter("deletedId");
		if(deletedId != null) {
			employeeDAO.delete(employeeDAO.getEmployee(Integer.parseInt(deletedId)));
		}
	
		// 表單參數
		String updatedIdfromForm = request.getParameter("updatedIdfromForm");
		String updatedName = request.getParameter("updatedName");
		String updatedWorkingHours = request.getParameter("updatedWorkingHours");
		String updatedHourlySalary = request.getParameter("updatedHourlySalary");
		
		if(updatedIdfromForm != null && updatedHourlySalary != null)
			employeeDAO.update(
				new Employee(
					Integer.parseInt(updatedIdfromForm), updatedName, 
					Integer.parseInt(updatedWorkingHours), Integer.parseInt(updatedHourlySalary)
				)
			);
		
	    %>
	
	
	<!-- INSERT FORM ------------------------------------------------------------------------------------------------>
	
	<h2> 新增員工 </h2>
	<br />
	<form class="form-inline" action="EmployeeManagement.jsp" method="POST">
		<div class="form-group">
		   <label for="name">姓名：</label>
		   <input type="text" class="form-control" id="name" name="name" required> &nbsp;
		</div>
		<div class="form-group">
		   <label for="workingHours">工時：</label>
		   <input type="number" class="form-control" id="workingHours" name="workingHours" required> &nbsp;
		 </div>
		 <div class="form-group">
		   <label for="hourlySalary">時薪：</label>
		   <input type="number" class="form-control" id="hourlySalary" name="hourlySalary" required> &nbsp;
		 </div>
		 <div class="form-group">
		   <input type="submit" value="新增">
		 </div>
	</form>
	
	<% 
		String name = request.getParameter("name");
		String workingHoursInput = request.getParameter("workingHours");
		String hourlySalaryInput = request.getParameter("hourlySalary");
		int hourlySalary = 0, workingHours = 0;
		
		
		if(hourlySalaryInput != null)
			hourlySalary = Integer.parseInt(hourlySalaryInput);
		if(workingHoursInput != null)
			workingHours = Integer.parseInt(workingHoursInput);
		
		if(name != null && workingHoursInput != null && hourlySalaryInput != null) {
			employeeDAO.insert(new Employee(name, workingHours, hourlySalary));
			out.println("新增員工成功");
		} else if(name != null || workingHoursInput != null || hourlySalaryInput != null) { 
			out.println("請填入完整的資料");
		} 
	%>
	
	<!-- SEARCH FORM ------------------------------------------------------------------------------>
	
	   <hr>
		<h2> 查詢員工 </h2>
		<br />
	   <form class="form-inline" action="EmployeeManagement.jsp" method="POST">
		<div class="form-group">
		   <label for="searchName">姓名：</label>
		   <input type="text" class="form-control" id="searchName" name="searchName" required> &nbsp;
		</div>
		       <input type="submit" value="搜尋"> &nbsp;
		       <a href="EmployeeManagement.jsp"> 清除 </a>
	   </form>
	   <br />
	   <br />
	 <% 
	 
	 String searchName = request.getParameter("searchName");
	 if(searchName != null){
	%>	 
		 <table class="table">
			<tr>
				<th> 員工編號 </td>
				<td> 名字  </td>
				<td> 工時 </td>
				<td colspan="3"> 時薪 </td>
				
			</tr>
			<% 
				ArrayList<Employee> employees= employeeDAO.search(searchName);
				for(Employee s : employees) {
			%>
				<tr>
					<td><%= s.id %></td>
					<td><%= s.name %></td>
					<td><%= s.workingHours %></td>
					<td><%= s.hourlySalary %></td>
					<td>
						<a href=<%= "EmployeeManagement.jsp?updatedId=" + s.id %>>
							點我修改
						</a>
					</td>
					<td>
						<a href=<%= "EmployeeManagement.jsp?deletedId=" + s.id %>>
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
		<th> 員工編號 </td>
		<td> 姓名  </td>
		<td> 工時 </td>
		<td colspan="3"> 時薪 </td>
	</tr>
	<% 
		ArrayList<Employee> employees = employeeDAO.getAllEmployees();
		for(Employee e : employees) {
	%>
		<tr>
			<td><%= e.id %></td>
			<td><%= e.name %></td>
			<td><%= e.workingHours %></td>
			<td><%= e.hourlySalary %></td>
			
			<td>
			<a href=<%= "EmployeeManagement.jsp?updatedId=" + e.id %>>點我修改</a>
				</td>
				
			<td>
			<a href=<%= "EmployeeManagement.jsp?deletedId=" + e.id %>>點我刪除</a>
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
		
		if(updatedId != null && updatedIdfromForm == null) {
			int id = Integer.parseInt(updatedId);
			Employee e = employeeDAO.getEmployee(id);
	%>
			<hr>
			<h3> 修改員工 </h3>
			<form class="form-inline" action="EmployeeManagement.jsp" method="POST">
				<div class="form-group">
					<label>員工編號：<e><%= e.id %></e> &nbsp;</label>
					<input type="number" name="updatedIdfromForm" value=<%= e.id %>
					style="display: None;">
				</div>
				<div class="form-group">
				   <label for="updatedName">姓名：</label> 
				   <input type="text" class="form-control" value=<%= e.name %>
				   id="updatedName" name="updatedName" required> &nbsp;
				</div>
				<div class="form-group">
				   <label for="updatedWorkingHours">工時：</label>
				   <input type="number" class="form-control" value=<%= e.workingHours %>
				   id="updatedWorkingHours" name="updatedWorkingHours" required> &nbsp;
				 </div>
				 <div class="form-group">
				   <label for="updatedHourlySalary">時薪：</label>
				   <input type="number" class="form-control" value=<%= e.hourlySalary %>
				   id="updatedHourlySalary" name="updatedHourlySalary" required> &nbsp;
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