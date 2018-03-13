<%@page import="models.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>BEI計算</title>

<%
	Class.forName("com.mysql.jdbc.Driver");
	java.sql.Connection con = Connector.getConn();
	DatabaseMetaData dbm = con.getMetaData();
	ResultSet rsTable = dbm.getTables(null, "database", null, null);
	ResultSetMetaData rsmd;
%>
<%@ include  file="InHead.html" %>
</head>
<body>
	<%@ include file="Header.html" %>
	<h2>損益平衡指數BEI</h2>

	<form name="selection" method="post" action="BEI.jsp">

		請選擇要計算損益平衡指數的資料表 <select id="table" name="table" size="1">
			<option>==請選擇表單==</option>
			<%
			while (rsTable.next()){
			%>
			<option value="<%=rsTable.getString("TABLE_NAME")%>"><%=rsTable.getString("TABLE_NAME")%></option>
			<%};
			%>
		</select>
		<p>
			每單位獲利= <input type="text" name="profit" id="profit"> 每單位成本= <input
				type="text" name="cost" id="cost">
		<p>
			<input type="submit" name="button" id="button" value="送出" />
		</p>
	</form>
	<p>
	<p>
		<%
			String stable = request.getParameter("table");
			String sprofit = request.getParameter("profit");
			String scost = request.getParameter("cost");
			int profit = 1;
			int cost = 0;
			
			if(sprofit !=null && scost !=null){
				profit = Integer.parseInt(sprofit);
				cost = Integer.parseInt(scost);
			}

			if (stable != null) {
				if (stable.equals("bei")) {

					Statement st= con.createStatement(); 
					String findRFM = "SELECT DISTINCT RFM FROM RFM";
					ResultSet rsRFM = st.executeQuery(findRFM);
					
					BEI exp2 = new BEI(profit,cost);
					double BE=exp2.getBE();
					out.println("BE= " +BE+"<br/><br/>");
					while(rsRFM.next()){
						
						String RFM = rsRFM.getString(1);
						String BEI=null;
							
							int rs=exp2.checkRFM(RFM);
						if( rs>0 ){
							BEI = exp2.GetBEI(RFM);
							exp2.updateRFM(BEI, RFM);
						}else{
							BEI = "null";
						}

						double dBEI = Double.valueOf(BEI).doubleValue();
						out.println("RFM分組為 "+RFM +" 的BEI值為&nbsp;&nbsp; ");
						if(dBEI > 0.0){
							out.println("<font color = red>"+dBEI+"</font><p>");
						}else{
							out.println(dBEI+"<p>");
						}
					}
				} else {
					out.println("該資料表或變數不能計算損益平衡指數  ");
				}
			}
		%>
	
</body>
</html>