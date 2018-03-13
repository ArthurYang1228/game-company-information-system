<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Connector, models.*, java.sql.Connection,java.util.ArrayList"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>進貨管理</title>
<%@ include  file="InHead.html" %>
</head>
<body>
	<%@ include  file="Header.html" %>
	
	
	

	<!-- DELTE FORM ------------------------------------------------------------------------------------------------>	
	<% 	
		request.setCharacterEncoding("UTF-8");
		String deletedId = request.getParameter("deletedId");
		
		
		Connection conn = Connector.getConn();
		PurchaseDAO purchaseDAO = new PurchaseDAO(conn);
		PurchaseDetailedDAO purchaseDetailedDAO = new PurchaseDetailedDAO(conn);
		InventoryDAO inventoryDAO = new InventoryDAO(conn);
		SupplierDAO supplierDAO = new SupplierDAO(conn);
		
		if(deletedId != null) {
			purchaseDetailedDAO.delete(purchaseDetailedDAO.get(Integer.parseInt(deletedId)));
		}
	%>
	
	<!-- Arr FORM ------------------------------------------------------------------------------------------------>	
	<% 	
		request.setCharacterEncoding("UTF-8");
		String arrId = request.getParameter("arrId");
		
		
		
		
		if(arrId != null) {
			purchaseDetailedDAO.checkArr(Integer.parseInt(arrId));
			PurchaseDetailed p = purchaseDetailedDAO.get(Integer.parseInt(arrId));
			Inventory i = inventoryDAO.getInventory(p.inventory.id);
			i.quantity += p.quantity;
			i.shipping -= p.quantity;
			inventoryDAO.update(i);
			PrepareTime pr = new PrepareTime(conn);
			pr.Compute();
		}
	%>


<!-- UPDATE FORM ------------------------------------------------------------------------------------------------>
	
	<%			
		String Iid = request.getParameter("Iid");
		String Sid = request.getParameter("Sid");
		String Purid = request.getParameter("Purid");
		String updatedQuantity = request.getParameter("updateQuantity");
		String updatedTotalPrice = request.getParameter("updateTotalPrice");
		String updateId = request.getParameter("updateId");
		
		if(Iid != null) {
			
		    purchaseDetailedDAO.update(
		    	new PurchaseDetailed(Integer.parseInt(updateId),
		    			Integer.parseInt(updatedQuantity),
		    			Integer.parseInt(updatedTotalPrice),
		    			inventoryDAO.getInventory(Integer.parseInt(Iid)),
		    			supplierDAO.getSupplier(Integer.parseInt(Sid))));
		    		   
		    out.print("更新成功");
		}
	%>
	
	<!-- SEARCH FORM ------------------------------------------------------------------------------>
		
		<h2>查詢進貨</h2>
		<br />
		<form class="form-inline" action="PurchaseManagement.jsp" method="POST">
		<div class="form-group">
		   <label for="searchName">搜尋日期： </label>
		   <input type="text" class="form-control" id="searchName" name="searchName" required> &nbsp;
		</div>
		 <input type="submit" value="搜尋">
		       <a href="PurchaseManagement.jsp"> 清除 </a>
	   </form>
		<br />	
	 <% 
	 
	 String searchName = request.getParameter("searchName");
	 if(searchName != null){
	%>	 
		<table class="table">
	<tr>
	     <td COLSPAN=3> 訂貨  </td>
	     <td colspan="7"> 細項  </td>
	</tr>
	
	<tr>
		<td> 訂貨編號 </td>
		<td> 日期 </td>

		<td> 貨名 </td>
		<td> 數量 </td>
		<td> 總價 </td>
        <td colspan="2"> 供應商  </td>
        		
	</tr>
	<% 
	 for(Purchase p : purchaseDAO.search(searchName)){
	    for(PurchaseDetailed pd : p.purchaseDetailedList) {
	    	if(p.purchaseDetailedList.indexOf(pd)==0) {
	%>
	   <tr>
			<td><%= p.id %></td>
			<td><%= p.date %></td>
			 
	        <td> <%= pd.inventory.name %> </td>
	        <td> <%= pd.quantity %> </td>
	        <td> <%= pd.totalPrice %> </td>	
			<td> <% 
				if(pd.supplier != null)
					out.print(pd.supplier.name);
				else
					out.print("deleted");
				%> </td>
		
			
			<td>
				<a href=<%= "PurchaseManagement.jsp?updateId=" + pd.id %>>
					點我修改
				</a>
			</td>
			<td>
				<a href=<%= "PurchaseManagement.jsp?deletedId=" + pd.id  %>>
					點我刪除
				</a>
			</td>
		</tr>
			
	<%
	     }
	     else{
	%>
	   <tr>
			<td COLSPAN=3>  </td>
			
	        <td> <%= pd.inventory.name %> </td>
	        <td> <%= pd.quantity %> </td>
	        <td> <%= pd.totalPrice %> </td>	
			<td> <%= pd.supplier.name %> </td>
			
			<td>
				<a href=<%= "PurchaseManagement.jsp?updateId=" + pd.id %>>
					點我修改
				</a>
			</td>
			<td>
				<a href=<%= "PurchaseManagement.jsp?deletedId=" + pd.id  %>>
					點我刪除
				</a>
			</td>
		</tr>
	
	
	
	<% 
		}
	   }
	 }
	%>
	</table>
	
	<%
	 }
			
//<!-- SHOW DATA ------------------------------------------------------------------------------------------------>	
	
 		else{ 
	%>

	<table class="table">
	<tr>
	     <td COLSPAN=3> 訂貨  </td>
	     <td colspan="7"> 細項  </td>
	</tr>
	
	<tr>
		<td> 訂貨編號 </td>
		<td> 訂貨日期 </td>
		<td> 到貨日期 </td>
		<td> 貨名 </td>
		<td> 數量 </td>
		<td> 總價 </td>
        <td colspan="3"> 供應商  </td>
        		
	</tr>
	<% 
	for(int index = purchaseDAO.getAllPurchases().size()-1 ; index >= 0 ; index-- ) {
		Purchase p = purchaseDAO.getAllPurchases().get(index);
	    for(PurchaseDetailed pd : p.purchaseDetailedList) {
	    	if(p.purchaseDetailedList.indexOf(pd)==0) {
	%>
	   <tr>
			<td><%= p.id %></td>
			<td><%= p.date %></td>
			
			<%
			String pin = "removed", psn = "removed";
			if(pd.inventory != null)
				pin = pd.inventory.name + "(" + pd.inventory.state + ")" ;
			if(pd.supplier != null)
				psn = pd.supplier.name;
			String arr = "shipping";
			if(pd.arrDate != null)
				arr = pd.arrDate;
			%>
			<td> <%= arr %> </td>
	        <td> <%= pin %> </td>
	        <td> <%= pd.quantity %> </td>
	        <td> <%= pd.totalPrice %> </td>	
			<td> <%= psn %> </td>
			
			<% 
			if(arr == "shipping"){
				%>

					
					<td>
					<a href=<%= "PurchaseManagement.jsp?arrId=" + pd.id %>>
						進貨確認
					</a>
				</td>
			<% 
			}else
			{
			
			%>
			<td>
			</td>
			<% 
			}
			
			%>
			<td>
				<a href=<%= "PurchaseManagement.jsp?updateId=" + pd.id %>>
					點我修改
				</a>
			</td>
			<td>
				<a href=<%= "PurchaseManagement.jsp?deletedId=" + pd.id  %>>
					點我刪除
				</a>
			</td>
		</tr>
			
	<%
	     }
	     else{
	%>
	   <tr>
			<td COLSPAN=2>  </td>
			<%
			String pin = "removed", psn = "removed";
			if(pd.inventory != null)
				pin = pd.inventory.name + "(" + pd.inventory.state + ")";
			if(pd.supplier != null)
				psn = pd.supplier.name;
			%>
	        <td> <%= pin %> </td>
	        <td> <%= pd.quantity %> </td>
	        <td> <%= pd.totalPrice %> </td>	
			<td> <%= psn %> </td>
			
			<td>
				<a href=<%= "PurchaseManagement.jsp?updateId=" + pd.id %>>
					點我修改
				</a>
			</td>
			<td>
				<a href=<%= "PurchaseManagement.jsp?deletedId=" + pd.id  %>>
					點我刪除
				</a>
			</td>
		</tr>
	
	
	
	<% 
		}
	   }
	 }
	%>
	</table>
	
	<%
		}
	 
	 if(updateId != null && Iid == null) {
			PurchaseDetailed pu = purchaseDetailedDAO.get(Integer.parseInt(updateId));
	%>
	<hr>
	<h2>修改訂單</h2>
	<br />
	<form class="form-inline" action=<%= "PurchaseManagement.jsp?updateId=" + updateId %> method="POST">
	貨名：  <select  class="form-control" name="Iid" value=<%= pu.inventory.id %>>
	<%
			for(Inventory i : inventoryDAO.getAllInventorys()) {
	%>
				<option value=<%=i.id %>><%=i.name  %></option>
	<%
			}
	%>
		</select>
	
		<div class="form-group">
		   <label for="updateQuantity">數量: </label>
		   <input type="number" class="form-control" id="updateQuantity" name="updateQuantity" value="pu.quantity"required> &nbsp;
		</div>
		<div class="form-group">
		   <label for="updateTotalPrice">總價:  </label>
		   <input type="number" class="form-control" id="updateTotalPrice" name="updateTotalPrice" value="pu.totalPrice"required> &nbsp;
		 </div>
		 供應商：  <select class="form-control" name="Sid" value=<%= pu.supplier.id %>>
	<%
			for(Supplier s : supplierDAO.getAllSuppliers() ) {
	%>
				<option value=<%=s.id %>><%=s.name  %></option>
	<%
			}
	%>
			</select>	
		 <div class="form-group">
		   <input type="submit" value="確認修改">
		 </div>
	</form>
	<% } %>
	
</body>
</html>