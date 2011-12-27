import os
import sys
import string
import urllib

sys.path.append(os.path.join(os.path.dirname(__file__), './'))

import jsonlib as json

print 'Content-type: text/html; charset=UTF-8'
print ''

import pptransact

#parse query string parameters into dictionary
params = {}
string_split = [s for s in os.environ['QUERY_STRING'].split('&') if s]
for item in string_split:
    key,value = item.split('=')
    if key != 'domain_unverified':
        params[key] = urllib.unquote(value)

returnObj = ''
if 'data' in params:
    data = params['data']
    data = string.split(data, '|')
    
    response = 'method=commitPayment&userId=%s&payerId=%s&token=%s&amt=%s&itemId=%s' % (data[1], params['PayerID'], params['token'], data[0], data[2])
    result = pptransact.commit(data[1], params['PayerID'], params['token'], data[0], data[2])

print '''
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Thank you</title>

<script src="https://www.paypalobjects.com/js/external/dg.js"></script>
<script src="../../client/jquery-1.6.2.min.js" type="text/javascript"></script>
<script src="../../client/pptransact.js"></script>

<script>
function closeFlow(){
    results = %s;
    jsonResults = jQuery.parseJSON(results.replace(/\\"/g,'\"'));
    pptransact.setUserId(jsonResults['userId']);
    pptransact.releaseDG(results);    
}

</script>
</head>

<body onload="closeFlow()">
<div style="background-color:#FFF;height:700px;width:300px; border-radius:8px;padding:20px;">
    Thank you for the purchase!<br />
    <button id="close" onclick="closeFlow();">close</button>
</div>
</body>
</html>
'''  % json.write(result)