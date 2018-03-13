<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<%@ page import = "java.sql.*, models.Connector" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=BIG5">
<title>訂購系統</title>
</head>
<body>
<%
int productid = Integer.parseInt(request.getParameter("productid"));
Class.forName("com.mysql.jdbc.Driver"); 
Connection conn = Connector.getConn();
Statement stmt = conn.createStatement();

String sql = "SELECT * FROM inventory WHERE id = '"+productid+"'";
ResultSet rst=stmt.executeQuery(sql);
if(!rst.next()){
	%>
	查無該品項
	<%
	return;
}else{
	rst.beforeFirst();
	rst.next();
	int economic = rst.getInt("economicQuantity");
	%>
	<form method="post" action="order_success.jsp">
		<font>欲進貨商品：<%= rst.getString("name")%></font><br>
		<font>經濟訂購量：<%= economic%></font><br>
		<font>您的進貨量：<input type="text" name="pquantity" value=<%= economic%>></font>
		<input type="hidden" value="<%= productid%>" name="productid">
		<input type="submit" value="訂購">
	</form>
	<%
	
	rst.close();
	stmt.close();
	conn.close();

}
%>
</body>
</html>