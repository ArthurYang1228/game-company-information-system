<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<%@ page import = "java.sql.*, models.Connector" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=BIG5">
<title>�q�ʨt��</title>
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
	�d�L�ӫ~��
	<%
	return;
}else{
	rst.beforeFirst();
	rst.next();
	int economic = rst.getInt("economicQuantity");
	%>
	<form method="post" action="order_success.jsp">
		<font>���i�f�ӫ~�G<%= rst.getString("name")%></font><br>
		<font>�g�٭q�ʶq�G<%= economic%></font><br>
		<font>�z���i�f�q�G<input type="text" name="pquantity" value=<%= economic%>></font>
		<input type="hidden" value="<%= productid%>" name="productid">
		<input type="submit" value="�q��">
	</form>
	<%
	
	rst.close();
	stmt.close();
	conn.close();

}
%>
</body>
</html>