<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Thank you</title>

<cfscript>
	responseStruct = StructNew();
	returnObj = StructNew();
	
	try {
		
		// create our objects to call methods on
		caller = createObject("component","/html5-dg/server/coldfusion/lib/services/CallerService");
		ec = createObject("component","/html5-dg/server/coldfusion/lib/ExpressCheckout");
		display = createObject("/html5-dg/server/coldfusion/lib/services/DisplayService");
		
		// DOEXPRESSCHECKOUTPAYMENT
		data = StructNew();
		data.method = "DoExpressCheckoutPayment";
		data.token = url.token;
		data.amt = url.amt;
		data.payerid = url.payerid;
		data.paymentAction = "sale";

		requestData = ec.setGetCheckoutData(request,data);
		
		response = caller.doHttppost(requestData);
		responseStruct = caller.getNVPResponse(#URLDecode(response)#);
	
		returnObj['transactionId'] = responseStruct.PAYMENTINFO_0_TRANSACTIONID;
		returnObj['orderTime'] = responseStruct.PAYMENTINFO_0_ORDERTIME;
		returnObj['paymentStatus'] = responseStruct.PAYMENTINFO_0_PAYMENTSTATUS;
		//returnObj['itemId'] = url.itemId;
		//returnObj['userId'] = url.userId;
	
		
		try {	
		
			data = StructNew();
			data.method = "GetTransactionDetails";
			data.transactionid = responseStruct.PAYMENTINFO_0_TRANSACTIONID;
	
			requestData = ec.setGetCheckoutData(request,data);
			
			response = caller.doHttppost(requestData);
			responseStruct = StructNew();
			responseStruct = caller.getNVPResponse(#URLDecode(response)#);
			
			returnObj['itemId'] = ListGetAt(responseStruct.CUSTOM,2,',');
			
		}
		
		catch(any e) 
		{
			writeOutput("Error: " & e.message);
			writeDump(responseStruct);
			abort;
		}
		
	
	}

	catch(any e) 
	{
		writeOutput("Error: " & e.message);
		writeDump(responseStruct);
		abort;
	}
</cfscript>

<script>

function closeFlow() {
    parent.xconnection.releaseDG(<cfoutput>#serializeJSON(returnObj)#</cfoutput>);
}

</script>
</head>

<body onload="closeFlow()">
<div style="background-color:#FFF;height:400px;width:300px; border-radius:8px;padding:20px;">
    Thank you for the purchase!
    <button id="close" onclick="closeFlow();">close</button>
</div>
</body>
</html>