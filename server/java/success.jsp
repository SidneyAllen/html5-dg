<%@ page language="java" import="net.sf.json.JSONObject"%>
<html>
<head>
<title>Thank you</title>
<script src="https://www.paypalobjects.com/js/external/dg.js"></script>
<script src="../../client/jquery-1.6.2.min.js" type="text/javascript"></script>
<script src="../../client/pptransact.js"></script>

<jsp:include page="pptransact.jsp">
	<jsp:param name="method" value="commitPayment" />
</jsp:include>

<script>

function parentExists() {
 	return (parent.location == window.location)? false : true;
}

function closeFlow(param) {
	
	pptransact.init('cf',true);
	
	if(!parentExists()) {
		var jsonData = $.parseJSON('<%=request.getAttribute("returnObj")%>');
		pptransact.saveToLocalStorage(jsonData.userId,<%=request.getAttribute("returnObj")%>,null);
		
		setTimeout ( forceCloseFlow, '3000' );
		
	} else {
		parent.pptransact.releaseDG(<%=request.getAttribute("returnObj")%>);
	}
  
}

function forceCloseFlow() {

	//The page you want to redirect the user after successfully storing data in local storage.
	window.location.href = '../../index.html';
		
}

</script>
</head>

<body onload="closeFlow(false)">
<div style="background-color:#FFF;height:400px;width:300px; border-radius:8px;padding:20px;">
    Thank you for the purchase!  You will automatically return to your site in 3 seconds.
    <button id="close" onclick="forceCloseFlow();">return now</button>
</div>
</body>
</html>