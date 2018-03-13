<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="BIG5"%>
<%@ page import = "java.sql.*, models.Connector" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>存貨狀況預估</title>
<%@ include  file="InHead.html" %>
</head>
<body>
<%@ include  file="Header.html" %>
<%
Class.forName("com.mysql.jdbc.Driver"); 
Connection conn = Connector.getConn();
Statement stmt = conn.createStatement();


ResultSet rs = stmt.executeQuery(
	"SELECT * FROM turnover"
);

if(rs.next()){
	float t = rs.getFloat("turnover");
	out.print("<h3>12月存貨周轉率:"+ t +"  週轉天數:"+ 30/t +"</h3>");
}
rs.close();


String sql = "SELECT * FROM inventory";
ResultSet rst=stmt.executeQuery(sql);
%>



<%
if(!rst.next()){
	%>
	目前沒有庫存資料！
	<%
	return;
}else{
	rst.beforeFirst();
%>
<table>
		<tr>
			<td>產品</td>
			<td>庫存</td>
			<td>平均日銷售</td>
			<td>進貨需時</td>
			<td>再訂購量(點)</td>
			<td>運送中數量</td>
			<td>進貨提醒</td>
		</tr>
		<%
		while(rst.next()){
			int a = rst.getInt("quantity");
			int b = rst.getInt("salesPerDay");
			int c = rst.getInt("orderTime");
			int d = rst.getInt("repurchaseQuantity");
			int e = rst.getInt("shippingQuantity");
			%>
			<tr>
				<td><%= rst.getString("name")%></td>
				<td><%= a%></td>
				<td><%= b%></td>
				<td><%= c%></td>
				<td><%= d%></td>
				<td><%= e%></td>
				<%
				if(a+e-b*c <= d){
					%>
					<td>
						<form method="post" action="NewPurchase.jsp">
							<input type="hidden" value="<%= rst.getInt("id")%>" name="productid">
							<input type="submit" value="立刻進貨">
						</form>
					</td>
					<%
				}else{
					%>
					<td>庫存充足</td>
					<%
				}
				%>
			</tr>
			<%
		}
		
		rst.close();
		stmt.close();
		conn.close();
		
}
%>
</table>
</body>
</html>