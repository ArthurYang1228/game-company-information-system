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
<title>RFM顧客分析</title>

<%
	Class.forName("com.mysql.jdbc.Driver");
	java.sql.Connection con = Connector.getConn();
	int i = 0;
	DatabaseMetaData dbm = con.getMetaData();
	ResultSet rsTable = dbm.getTables(null, "test", null, null);
%>
<%@ include  file="InHead.html" %>
</head>
<body>
	<%@ include file="Header.html" %>
	<h2>RFM分群</h2>

	<form name="selection" method="post" action="RFM.jsp">

		請選擇要進行RFM分析的資料表 <select id="table" name="table">
			<option>==請選擇表單==</option>
			<%
				while (rsTable.next()) {
			%>
			<option value="<%=rsTable.getString("TABLE_NAME")%>"><%=rsTable.getString("TABLE_NAME")%></option>
			<%
				}
				;
			%>
		</select>
		<p>
			<input type="submit" name="button" id="button" value="送出" />
		</p>
	</form>
	<p>
	<p>
		<%
			String table = request.getParameter("table");

			if (table != null) {
				if (table.equals("salerecord")) {

					PreparedStatement SQL = con.prepareStatement("SELECT * FROM RFM WHERE RID=?");
					String sql = "SELECT id FROM customer;";
					Statement st= con.createStatement(); 
					ResultSet rs=st.executeQuery(sql); 
					RFM exp = new RFM();

					int res = 0;
					while(rs.next()) {
						String CID = rs.getString(1);
						int m = exp.GetMoney(CID);
						int f = exp.GetFrequency(CID);
						String r = exp.GetRecency(CID);

						SQL.setInt(1, rs.getInt(1));
						ResultSet rs2 = SQL.executeQuery();
						if (rs2.next()) {
							exp.update(CID, r, f, m);
						} else {
							exp.insert(CID, r, f, m);
						}
					}

					for (int a = 1; a <= 18; a++) {
						String CID = String.valueOf(a);
						String rfm = exp.GetRFM(CID);

						exp.updateRFM(CID, rfm);
					}

					Statement st2 = con.createStatement();
					PreparedStatement findCus = con.prepareStatement("SELECT CID FROM RFM WHERE RFM=?");
					PreparedStatement findName = con.prepareStatement("SELECT name FROM customer WHERE id=?");
					String sql3 = "SELECT DISTINCT RFM FROM RFM";
					ResultSet allRFM = st2.executeQuery(sql3);

					while (allRFM.next()) {
						out.println("RFM屬於 " + allRFM.getString(1) + " 組別的顧客有：" + "<br/>");

						String RFM = allRFM.getString(1);
						findCus.setString(1, RFM);
						ResultSet CID = findCus.executeQuery();
						while (CID.next()) {
							String formatStr = "%02d";
							String sCID = String.format(formatStr, CID.getInt(1));
							findName.setString(1, sCID);
							ResultSet customer = findName.executeQuery();
							while (customer.next()) {
								String name = customer.getString(1);
								out.println(sCID + "&nbsp;&nbsp;&nbsp;" + name + "<br/>");
							}
						}
						out.println("<p>");
					}
				} else {
					out.println("該資料表不能進行RFM分群  ");
				}
			}
		%>
	
</body>
</html>