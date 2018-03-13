<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import ="javax.sql.*" %>
<%@ page import ="java.util.*" %>
<%@ page import ="java.lang.Number" %>
<%@ page import ="marketing.RFM" %>
<%@ page import ="marketing.BEI" %>
<%@ page import ="marketing.Logistic" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>RFM顧客分析</title>
</head>
<body> 
<h2>RFM分群</h2>
<% 

Class.forName("com.mysql.jdbc.Driver");
java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/database","root","1234");
Statement st= con.createStatement(); 
PreparedStatement SQL = con.prepareStatement("SELECT CID FROM RFM WHERE RID=?");

Logistic logistic = new Logistic(1);
logistic.train();
int[] x = {0};
out.println("prob(1|x=0) = " + logistic.classify(x) +"<br/>");

int[] x2 = {1};
out.println("prob(1|x=1) = " + logistic.classify(x2)+"<br/>");


/*
String sql = "SELECT x,y FROM logistic;";
ResultSet rs=st.executeQuery(sql); 

int i = (34799-800)/11333;
while (rs.next()){
    out.println("X=" + rs.getString(1) + " Y=" + rs.getString(2)+ "<br/>");

} 

out.println(i);
*/

BEI exp2 = new BEI(45,1);
RFM exp = new RFM();
/*
for(int i = 1; i<=18 ; i++){
	String CID = String.valueOf(i);
	int m = exp.GetMoney(CID);
	int f = exp.GetFrequency(CID);
	String r = exp.GetRecency(CID);
	
	out.println(i +"<br/>"+"R= "+ r +" F= " + f + " M= " + m +"<br/>");
	
	
	SQL.setInt(1,i);
	ResultSet rs=SQL.executeQuery(); 
	if(rs.next()){
		exp.update(CID, r, f, m);
	}else{
		exp.insert(CID, r, f, m);
	}
}
*/
/*
for(int i = 1; i<=18 ; i++){
	String CID = String.valueOf(i);
	String rfm = exp.GetRFM(CID);
	
	out.println(i +"<br/>"+"RFM= "+ rfm +"<br/>");
	
	
		exp.updateRFM(CID, rfm);
}
*/

for(int r=1 ; r<=3 ; r++){
	for(int f=1 ; f<=3 ; f++){
		for(int m=1 ; m<=3 ; m++){
			
			int rfm=100*r+10*f+m;
			String RFM = String.valueOf(rfm);
			String BEI=null;
			
			int rs=exp2.checkRFM(RFM);
			if( rs>0 ){
				BEI = exp2.GetBEI(RFM);
				exp2.updateRFM(BEI, RFM);
			}else{
				BEI = "null";
			}

			out.println(RFM +"<br/>"+"BEI= "+ BEI +"<br/>");
		}
	}
}

	
%> 

</body>
</html>