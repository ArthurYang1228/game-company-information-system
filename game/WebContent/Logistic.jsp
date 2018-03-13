<%@page import="models.Logistic, models.Connector"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>邏輯回歸分析</title>

<%
	Class.forName("com.mysql.jdbc.Driver");
	java.sql.Connection con = Connector.getConn();
	int i = 0;
	DatabaseMetaData dbm = con.getMetaData();
	ResultSet rsTable = dbm.getTables(null, "database", null, null);
	ResultSetMetaData rsmd;
%>
<script>
function ChangeSelect(table,col1,col2)
{
val = table.options[table.options.selectedIndex].value;
  
  <%while (rsTable.next()) {
				String tableName = rsTable.getString(3);
				ResultSet rsCol = dbm.getColumns(null, "database", tableName, null);
				rsmd = rsCol.getMetaData();%>
  if (val == '<%=rsTable.getString("TABLE_NAME")%>')
  {  
    <%while (rsCol.next()) {
					i++;
				}%>
    col1.length = <%=i%>;
    col2.length = <%=i%>;
    <%i = 0;
				rsCol.first();
		do{%>
    table.options[<%=i%>].value = '<%=rsTable.getString("TABLE_NAME")%>'; 
    table.options[<%=i%>].text = '<%=rsTable.getString("TABLE_NAME")%>';
    col1.options[<%=i%>].value = '<%=rsCol.getString("COLUMN_NAME")%>'; 
    col1.options[<%=i%>].text = '<%=rsCol.getString("COLUMN_NAME")%>'; 
    col2.options[<%=i%>].value = '<%=rsCol.getString("COLUMN_NAME")%>'; 
    col2.options[<%=i%>].text = '<%=rsCol.getString("COLUMN_NAME")%>';
	<%	
    i++;
		}while (rsCol.next());
		i = 0;%>
	}
<%}
			rsTable.first();%>
	}
</script>
<%@ include  file="InHead.html" %>
</head>
<body>
	<%@ include file="Header.html" %>
	<h2>邏輯回歸</h2>

	<form name="selection" method="post" action="Logistic.jsp">

		請選擇要進行邏輯回歸分析的資料表 <select id="table" name="table"
			onchange="ChangeSelect(document.selection.table,document.selection.col1,document.selection.col2)"
			size="1">
			<option>==請選擇表單==</option>
			<%
			while (rsTable.next()){
			%>
			<option value="<%=rsTable.getString("TABLE_NAME")%>"><%=rsTable.getString("TABLE_NAME")%></option>
			<%};
			%>
		</select>
		<p>
			自變數X= <select name="col1" id="col1">
			</select> 應變數Y= <select name="col2" id="col2">
			</select>
		<p>
			<input type="submit" name="button" id="button" value="送出" />
		</p>
	</form>
	<p>
	<p>
		<%
			String stable = request.getParameter("table");

			if (stable != null) {
				if (stable.equals("logistic")) {

					Logistic logistic = new Logistic(1);
					logistic.train();
					int[] x = {1,0};
					out.println("x=0時成功的機率 = " + logistic.classify(x) +"<p>");

					int[] x2 = {1,1};
					out.println("x=1時成功的機率  = " + logistic.classify(x2)+"<p>");
				} else {
					out.println("該資料表或變數不能進行邏輯回歸  ");
				}
			}
		%>
	
</body>
</html>