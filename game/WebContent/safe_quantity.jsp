<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<%@ page import = "java.sql.*, models.Connector" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=BIG5">
<title>安全存量預測</title>
</head>
<body>
<%
Class.forName("com.mysql.jdbc.Driver"); 
Connection conn = Connector.getConn();
Statement stmt = conn.createStatement();
%>
</body>
</html>