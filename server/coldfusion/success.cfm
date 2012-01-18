<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Thank you</title>
<script src="https://www.paypalobjects.com/js/external/dg.js"></script>
<script src="../../client/jquery-1.6.2.min.js" type="text/javascript"></script>
<script src="../../client/pptransact.js"></script>

<cfscript>
	returnObj = StructNew();
	
	try {
		// COMMIT PAYMENT
		pptransact = createObject("component","pptransact");
		returnObj = pptransact.commitPayment(url.userId,url.payerId,url.token,url.amt,url.itemId);	
	
	}

	catch(any e) 
	{
		writeOutput("Error: " & e.message);
		abort;
	}
</cfscript>

<script>


function parentExists()
{
 	return (parent.location == window.location)? false : true;
}

function closeFlow(param) {
	
	if(param)
	{
		window.location.href = '../../index.html';
	}
	
	pptransact.init('cf',true);
	
	if(!parentExists())
	{
		var jsonData = $.parseJSON('<cfoutput>#returnObj#</cfoutput>');
		pptransact.saveToLocalStorage(jsonData.userId,<cfoutput>#returnObj#</cfoutput>,null);
		
	} else {
		parent.pptransact.releaseDG(<cfoutput>#returnObj#</cfoutput>);
	}
  
}

</script>
</head>

<body onload="closeFlow(false)">
<div style="background-color:#FFF;height:400px;width:300px; border-radius:8px;padding:20px;">
    Thank you for the purchase!
    <button id="close" onclick="closeFlow(true);">close</button>
</div>
</body>
</html>