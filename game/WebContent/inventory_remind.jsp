<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="BIG5"%>
<%@ page import = "java.sql.*, models.Connector" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>�s�f���p�w��</title>
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
	out.print("<h3>12��s�f�P��v:"+ t +"  �g��Ѽ�:"+ 30/t +"</h3>");
}
rs.close();


String sql = "SELECT * FROM inventory";
ResultSet rst=stmt.executeQuery(sql);
%>



<%
if(!rst.next()){
	%>
	�ثe�S���w�s��ơI
	<%
	return;
}else{
	rst.beforeFirst();
%>
<table>
		<tr>
			<td>���~</td>
			<td>�w�s</td>
			<td>������P��</td>
			<td>�i�f�ݮ�</td>
			<td>�A�q�ʶq(�I)</td>
			<td>�B�e���ƶq</td>
			<td>�i�f����</td>
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
							<input type="submit" value="�ߨ�i�f">
						</form>
					</td>
					<%
				}else{
					%>
					<td>�w�s�R��</td>
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