<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Product, models.ProductDAO, models.Order, models.OrderDAO, models.OrderDetailed, models.Connector, 
			java.sql.Connection, java.util.Enumeration, java.util.ArrayList, models.EmployeeDAO, models.Employee, 
			java.util.Date, java.text.SimpleDateFormat, java.text.DateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新增訂單</title>
<script type="text/javascript" language="javascript">
	function onSelected(id, beforeProducts) {
		if(beforeProducts == "0") {
			toUrl = "/TryIt/NewOrder.jsp?products=" + id + "-" + 
				document.getElementById("sugar"+id).value + "-" + document.getElementById("ice"+id).value + ",";
		}
		else {
			toUrl = "/TryIt/NewOrder.jsp?products=" + beforeProducts + id + "-" + 
				document.getElementById("sugar"+id).value + "-" + document.getElementById("ice"+id).value + ",";
		}
		window.location.replace(toUrl);
	}
</script>
<%@ include file="InHead.html" %>
</head>
<body>
	<%@ include  file="Header.html" %>
	<table class="table">
		<tr>
			<td> 品名 </td>
			<td> 糖度</td>
			<td colspan="2"> 冰塊 </td>
		</tr>
	<%
	request.setCharacterEncoding("UTF-8");
		String productsInput = request.getParameter("products");
		
		String beforProducts;
		if(productsInput == null) {
			beforProducts = "0";
		} else {
			beforProducts = productsInput;
		}
		Connection conn = Connector.getConn();
		ProductDAO productDAO = new ProductDAO(conn);
		EmployeeDAO employeeDAO = new EmployeeDAO(conn);
	    ArrayList<Product> products = productDAO.getAllProducts();
	    
	    %>
	    員工編號：<select name="eId" >
		<%
				for(Employee e : employeeDAO.getAllEmployees()) {
		%>
					<option value=<%=e.id %>><%=e.id+"  "+e.name %></option>
		<%
				}
		%>
				</select>
	<% 	
	    for(Product p: products) {
	%>
		<tr>
			<td> <%= p.name + "(" + p.size + ")" %> </td>
			<td>
				<select id=<%= "sugar" + p.id %>> 
					<option value="5">正常</option> 
					<option value="4">少糖</option> 
					<option value="3">半糖</option>
					<option value="2">微糖</option> 
					<option value="1">無糖</option> 
				</select>
			</td>
			<td>
				<select id=<%= "ice" + p.id %>> 
					<option value="5">正常</option> 
					<option value="4">少冰</option> 
					<option value="3">微冰</option>
					<option value="2">去冰</option> 
					<option value="1">溫熱</option> 
				</select>
			</td>
			<td> <a href="#" onclick="onSelected(<%= p.id %>,'<%= beforProducts %>')"> 新增 </a> </td>
		</tr>
	<%
	    }
	%>
	</table>
	
	<hr>
	
	<table class="table">
	<% 
		if(productsInput != null) {
			String[] productInfos = productsInput.split(",");
			for(String productInfo: productInfos) {
				String[] pInfo = productInfo.split("-");
				int productId = Integer.parseInt(pInfo[0]);
				String sugar = pInfo[1];
				switch(sugar) {
					case "5": sugar = "正常"; break;
					case "4": sugar = "少糖"; break;
					case "3": sugar = "半糖"; break;
					case "2": sugar = "微糖"; break;
					case "1": sugar = "無糖"; break;
				}
				String ice = pInfo[2];
				switch(ice) {
					case "5": ice = "正常"; break;
					case "4": ice = "少冰"; break;
					case "3": ice = "微冰"; break;
					case "2": ice = "去冰"; break;
					case "1": ice = "溫熱"; break;
				}
				Product p = productDAO.getProduct(productId);
	%>
				<tr><p><%= p.name + " " + sugar + " " + ice %>
				<a href=<%= "/TryIt/NewOrder.jsp?products=" + productsInput.replaceFirst(productInfo+",", "") %>> 刪除 </a></p></tr>
	<%
			}
		}
	%>
	</table>
	
	<form action="NewOrder.jsp" method="POST">
		
		<input type="text" name="postProductsInput" value=<%= productsInput %> 
		style="display: None;"></input>
	
	<% 	
	if(productsInput != null){
	
	%>
		<input type="submit" value="確認點餐"> <a href="NewOrder.jsp"> 清除全部 </a>
	<%
		}
	%>
	</form>
	
	<%	
	
	
		String postProductsInput = request.getParameter("postProductsInput");
		String eId = request.getParameter("eId");
		if(postProductsInput != null && eId != null) {
			String[] postProduct = postProductsInput.split(",");
			
			Date date = new Date();
			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			DateFormat timeFormat = new SimpleDateFormat("HH:mm");
			
			OrderDAO orderDAO = new OrderDAO(conn);
			Order order = new Order(dateFormat.format(date), timeFormat.format(date),
					new EmployeeDAO(conn).getEmployee(Integer.parseInt(eId)));
			for(String s: postProduct) {
				
				String[] s2 = s.split("-");
				int productId = Integer.parseInt(s2[0]);
				String sugar = s2[1];
				String ice = s2[2];
				OrderDetailed o = new OrderDetailed(sugar, ice, productDAO.getProduct(productId));
				o.product.consume(conn);
				order.addOrderDetailed(o);
			}
			orderDAO.insert(order);
			out.print("新增成功");
		}
	%>
</body>
</html>