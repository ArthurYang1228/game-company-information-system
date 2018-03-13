<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<%@ page import = "java.sql.*, models.Connector" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=BIG5">
<title>再訂購量計算</title>
</head>
<body>
<%
Class.forName("com.mysql.jdbc.Driver"); 
Connection conn = Connector.getConn();
Statement stmt = conn.createStatement();

String sql = "SELECT * FROM product";
ResultSet rst=stmt.executeQuery(sql);
if(!rst.next()){
	%>
	目前沒有庫存資料
	<%
	return;
}else{
	rst.beforeFirst();
	int e = 0;
	
	while(rst.next()){
		int a = rst.getInt("salesPerDay");
		int b = rst.getInt("orderDays");
		int c = a*b;
		int d = rst.getInt("productid");
		
		Statement stmt2 = conn.createStatement();
		e = stmt2.executeUpdate("UPDATE product SET repurchaseQuantity = '"+c+"' WHERE productid = '"+d+"'");
		stmt2.close();
	}
}
stmt.close();
conn.close();
%>
</body>
</html>