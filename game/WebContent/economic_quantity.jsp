<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=BIG5">
<title>經濟訂購量預測</title>
</head>
<body>
<%
Class.forName("com.mysql.jdbc.Driver"); 
Connection conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/mesmartlin?useUnicode=true&characterEncoding=big5","admin", "sam961217");
Statement stmt = conn.createStatement();
%>
</body>
</html>