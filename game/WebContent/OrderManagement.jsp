<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Connector, models.Order, models.Product, models.ProductDAO, models.OrderDAO,
java.sql.Connection,  models.OrderDetailedDAO, models.OrderDetailed, models.Employee, java.util.ArrayList"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>訂單管理</title>
<%@ include  file="InHead.html" %>
</head>
<body>
	<%@ include file="Header.html" %>


<!-- DELTE FORM ------------------------------------------------------------------------------------------------>	
	<% 	
		request.setCharacterEncoding("UTF-8");
		String deletedId = request.getParameter("deletedId");
		String pid = request.getParameter("pid");
		String updatedSugar = request.getParameter("updatedsugar");
		String updatedIce = request.getParameter("updatedice");
		String updateId = request.getParameter("updateId");
		
		
		Connection conn = Connector.getConn();
		OrderDAO orderDAO = new OrderDAO(conn);
		OrderDetailedDAO orderDetailedDAO = new OrderDetailedDAO(conn);
		ProductDAO productDAO = new ProductDAO(conn);
		
		if(deletedId != null) {
			OrderDetailed od = orderDetailedDAO.get(Integer.parseInt(deletedId));
			if(od.product != null)
				od.product.consume(conn, -1);
			orderDetailedDAO.delete(od);
		}
		
		if(pid != null) {
			int newpid = Integer.parseInt(pid);
			Product p = new OrderDetailedDAO(conn).get(Integer.parseInt(updateId)).product;
			if(p != null)
				p.consume(conn, -1);
			OrderDetailed od = new OrderDetailed(
					Integer.parseInt(updateId), updatedSugar , updatedIce , productDAO.getProduct(newpid));
		    // 新的消耗
			od.product.consume(conn);
			orderDetailedDAO.update(od);
		    out.print("更新成功");
		}
	%>

<!-- SEARCH FORM ------------------------------------------------------------------------------>
	
	   <form action="OrderManagement.jsp" method="POST">
		<label>查詢訂單</label>
		搜尋日期： <input type="text" name="searchName">
		       <input type="submit" value="搜尋">
		       <a href="OrderManagement.jsp"> 清除 </a>
		 
	   </form>
	   
	 <% 
	 
	 String searchName = request.getParameter("searchName");
	 
	 
	 if(searchName != null){
	%>	 
	<table class="table">
	<tr>
	     <td COLSPAN=4> 訂單  </td>
	     <td COLSPAN=5> 細項  </td>
	</tr>
	
	<tr>
		<td> 訂單編號 </td>
		<td> 日期 </td>
		<td> 時間 </td>
		<td> 員工 </td>
		
		<td> 品名 </td>
		<td> 容量 </td>
		<td> 糖量 </td>
        <td> 冰量  </td>
        <td> 價錢  </td>		
	</tr>
	<% 
	for(Order o: orderDAO.search(searchName)) {
	    for(OrderDetailed od : o.orderDetailedList) {
	    	if(o.orderDetailedList.indexOf(od) == 0) {
	%>
	   <tr>
			<td><%= o.id %></td>
			<td><%= o.date %></td>
			<td><%= o.time %></td>
		    <td>
		    <% 
		    	if(o.employee == null)
		    		out.print("quit");
	    		else
	    			out.print(o.employee.name);				
	    	%>
			</td>
			
	        <td> <%= od.product.name %> </td>
	        <td> <%= od.product.size %> </td>
	        <td> <%= od.sugar %> </td>	
			<td> <%= od.ice %> </td>
			<td> <%= od.product.price %> </td>
			
			<td>
				<a href=<%= "OrderManagement.jsp?updateId=" + od.id %>>
					點我修改
				</a>
			</td>
			<td>
				<a href=<%= "OrderManagement.jsp?deletedId=" + od.id  %>>
					點我刪除
				</a>
			</td>
		</tr>
			
	<%
	     }
	     else{
	%>
	   <tr>
			<td COLSPAN=4>  </td>
			
	        <td> <%= od.product.name %> </td>
	        <td> <%= od.product.size %> </td>
	        <td> <%= od.sugar %> </td>	
			<td> <%= od.ice %> </td>
			<td> <%= od.product.price %> </td>
			
			<td>
				<a href=<%= "OrderManagement.jsp?updateId=" + od.id %>>
					點我修改
				</a>
			</td>
			<td>
				<a href=<%= "OrderManagement.jsp?deletedId=" + od.id  %>>
					點我刪除
				</a>
			</td>
		</tr>
	
	
	
	<% 
		}
	  }
	}
	%>
	</table>
	
	<%
	 }
	 
			
//<!-- SHOW DATA ------------------------------------------------------------------------------------------------>	
	else{
		
	%>
	<table class="table">
	<tr>
	     <td COLSPAN=4> 訂單  </td>
	     <td COLSPAN=5> 細項  </td>
	</tr>
	
	<tr>
		<td> 訂單編號 </td>
		<td> 日期 </td>
		<td> 時間 </td>
		<td> 員工 </td>
		<td> 品名 </td>
		<td> 容量 </td>
		<td> 糖量 </td>
        <td> 冰量  </td>
        <td> 價錢  </td>		
	</tr>
	<% 
	for(int index = orderDAO.getAllOrders().size()-1 ; index >= 0 ; index-- ) {
		Order o = orderDAO.getAllOrders().get(index);
	    for(OrderDetailed od : o.orderDetailedList) {
	    	if(o.orderDetailedList.indexOf(od) == 0) {
	    		
	%>
	   <tr>
			<td><%= o.id %></td>
			<td><%= o.date %></td>
			<td><%= o.time %></td>
			<td><% 
				if(o.employee != null) {
					out.print(o.employee.id);
				} else {
					out.print("quit");
				}
				%>
			</td>
				<%
				String odn="removed", ods="", odp="";
				if(od.product != null)  {
					odn = od.product.name;
					ods = od.product.size;
					odp = String.valueOf(od.product.price);
				}
				String sugar = od.sugar;
				switch(sugar) {
					case "5": sugar = "正常"; break;
					case "4": sugar = "少糖"; break;
					case "3": sugar = "半糖"; break;
					case "2": sugar = "微糖"; break;
					case "1": sugar = "無糖"; break;
				}
				String ice = od.ice;
				switch(ice) {
					case "5": ice = "正常"; break;
					case "4": ice = "少冰"; break;
					case "3": ice = "微冰"; break;
					case "2": ice = "去冰"; break;
					case "1": ice = "溫熱"; break;
				}
				%>
	        <td> <%= odn %> </td>
	        <td> <%= ods %> </td>
	        <td> <%= sugar %> </td>	
			<td> <%= ice %> </td>
			<td> <%= odp %> </td>
			
			<td>
				<a href=<%= "OrderManagement.jsp?updateId=" + od.id %>>
					點我修改
				</a>
			</td>
			<td>
				<a href=<%= "OrderManagement.jsp?deletedId=" + od.id  %>>
					點我刪除
				</a>
			</td>
		</tr>
			
	<%
	     }
	     else{
	%>
	   <tr>
			<td COLSPAN=4>  </td>
			
			<%
				String odn="removed", ods="", odp="";
				if(od.product != null)  {
					odn = od.product.name;
					ods = od.product.size;
					odp = String.valueOf(od.product.price);
				}
			%>
			<%
				String sugar = od.sugar;
				switch(sugar) {
					case "5": sugar = "正常"; break;
					case "4": sugar = "少糖"; break;
					case "3": sugar = "半糖"; break;
					case "2": sugar = "微糖"; break;
					case "1": sugar = "無糖"; break;
				}
				String ice = od.ice;
				switch(ice) {
					case "5": ice = "正常"; break;
					case "4": ice = "少冰"; break;
					case "3": ice = "微冰"; break;
					case "2": ice = "去冰"; break;
					case "1": ice = "溫熱"; break;
				}
			%>
				
	        <td> <%= odn %> </td>
	        <td> <%= ods %> </td>
	        <td> <%= sugar %> </td>	
			<td> <%= ice %> </td>
			<td> <%= odp %> </td>
			
			<td>
				<a href=<%= "OrderManagement.jsp?updateId=" + od.id %>>
					點我修改
				</a>
			</td>
			<td>
				<a href=<%= "OrderManagement.jsp?deletedId=" + od.id  %>>
					點我刪除
				</a>
			</td>
		</tr>
	
	
	
	<% 
		}
	  }
	}
	%>
	</table>
	
	<%
		}	
	%>
	
	<!-- UPDATE FORM ------------------------------------------------------------------------------------------------>
	
	<%		
		if(updateId != null && pid == null) {
			OrderDetailed updateOD = orderDetailedDAO.get(Integer.parseInt(updateId));
			Product oDP = updateOD.product;
			String oDPId;
			if(oDP != null)
				oDPId = "value=" + oDP.id;
			else
				oDPId = "";
	%>
		<form action=<%= "OrderManagement.jsp?updateId=" + updateId %> method="POST">
			品名：  <select name="pid" <%= oDPId %>>
	<%
			for(Product p : productDAO.getAllProducts()) {
	%>
				<option value=<%=p.id %>><%=p.name + p.size %></option>
	<%
			}
	%>
			</select>
				糖量： 
				<select name="updatedsugar" value=<%=updateOD.sugar %>>
					<option value="5">正常</option>
					<option value="4">少糖</option>
					<option value="3">半糖</option>
					<option value="2">微糖</option>
					<option value="1">無糖</option>
				</select>
				冰量: 
				<select name="updatedice" value=<%=updateOD.ice %>>
					<option value="5">正常</option>
					<option value="4">少冰</option>
					<option value="3">微冰</option>
					<option value="2">去冰</option>
					<option value="1">熱</option>
				</select>
				         
				<input type="submit" value="確認修改">
		</form>
		
	<% 
		}
		
	%>
	
</body>
</html>