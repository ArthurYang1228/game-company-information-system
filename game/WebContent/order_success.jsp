<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<%@ page import = "java.sql.*, models.Connector" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=BIG5">
<title>訂購成功</title>
</head>
<body>
<%
int productid = Integer.parseInt(request.getParameter("productid"));
int quantity = Integer.parseInt(request.getParameter("pquantity"));
Class.forName("com.mysql.jdbc.Driver"); 
Connection conn = Connector.getConn();
Statement stmt = conn.createStatement();

String sql = "SELECT shippingQuantity FROM inventory WHERE id = '"+productid+"'";
ResultSet rst=stmt.executeQuery(sql);

if(!rst.next()){
	%>
	發生錯誤
	<%
}else{
	
	int orderplus = rst.getInt("shippingQuantity")+quantity;
	rst.close();
	
	Statement stmt2 = conn.createStatement();
	int order = stmt2.executeUpdate("UPDATE inventory SET shippingQuantity = '"+orderplus+"' WHERE id = '"+productid+"'");
	stmt2.close();
	
}
stmt.close();
%>
<font><a href='inventory_remind.jsp'>進貨成功</a></font><br>
<%
Statement stmt3 = conn.createStatement();
String sql2 = "SELECT * FROM inventory WHERE id != '"+productid+"'";
ResultSet rst2=stmt3.executeQuery(sql2);
if(!rst2.next()){
	%>
	目前毋須進貨！
	<%
	return;
}else{
	rst2.beforeFirst();
	%>
	您還有
	<%
	while(rst2.next()){
		int a = rst2.getInt("quantity");
		int b = rst2.getInt("salesPerDay");
		int c = rst2.getInt("orderDays");
		int d = rst2.getInt("repurchaseQuantity");
		int e = rst2.getInt("shippingQuantity");
		
		if(a+e-b*c <= d){
			%>
			<form method="post" action="order.jsp">
				<input type="hidden" value="<%= rst2.getInt("id")%>" name="productid">
				<input type="submit" value="<%= rst2.getString("name")%>">
			</form>
			<%
		}
	}
	%>
	需要進貨
	<%
	rst2.close();
	stmt3.close();
	conn.close();
}
%>
</body>
</html>