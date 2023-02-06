//%attributes = {"invisible":true,"preemptive":"capable"}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 29/09/22, 14:41:04
// ----------------------------------------------------
// Method: MGRAPH_Make_Request
// Description
// 
//
// Parameters
// $0 - Object     - Response
// $1 - Text       - Client ID
// $2 - Text       - Endpoint
// $3 - Text       - Request Type
// $3 - Collection - Query Params
// $4 - Collection - Additional Headers
// $5 - Variant    - Post Body
// ----------------------------------------------------

var $0; $vo_response : Object
var $1; $vv_authParam : Variant
var $2; $vt_endpoint; $3; $vt_requestType : Text
var $4; $vc_params; $5; $vc_headers : Collection
var $6; $v_body : Variant

var $vt_authType; $vt_url; $vt_response; $vt_param : Text
var $vl_status; $vl_index : Integer
var $vo_header; $vo_param; $vo_tokenResponse : Object
var $vc_responseHeaders : Collection

var vl_httpError; vl_jsonError : Integer
var vt_httpError; vt_jsonError : Text

$vo_response:=New object:C1471
$vc_params:=New collection:C1472
$vc_headers:=New collection:C1472
$v_body:=""

If (Count parameters:C259>0)
	$vv_authParam:=$1
	If (Value type:C1509($1)=Is text:K8:3)
		$vt_authType:="client"
	Else 
		$vt_authType:="auth"
	End if 
End if 
If (Count parameters:C259>1)
	$vt_endpoint:=$2
End if 
If (Count parameters:C259>2)
	$vt_requestType:=$3
End if 
If (Count parameters:C259>3)
	$vc_params:=$4
End if 
If (Count parameters:C259>4)
	$vc_headers:=$5
End if 
If (Count parameters:C259>5)
	$v_body:=$6
End if 

ARRAY TEXT:C222($at_headerName; 0)
ARRAY TEXT:C222($at_headerValue; 0)

If ($vt_endpoint#"")
	
	$vo_tokenResponse:=MGRAPH_Get_Access_Token($vt_authType; $vv_authParam)
	
	If ($vo_tokenResponse.success)
		
		If ($vt_authType="client")
			$vl_index:=Storage:C1525.clients.findIndex("UTIL_Find_Collection"; "clientId"; $vv_authParam)
			$vt_url:=Storage:C1525.clients[$vl_index].baseUrl+$vt_endpoint
		Else 
			$vt_url:=$vv_authParam.baseApiUrl+$vt_endpoint
		End if 
		
		For each ($vo_param; $vc_params)
			If ($vt_param#"")
				$vt_param:=$vt_param+"&"
			End if 
			$vt_param:=$vt_param+$vo_param.name+"="+$vo_param.value
		End for each 
		
		If ($vt_param#"")
			$vt_url:=$vt_url+"?"+$vt_param
		End if 
		
		APPEND TO ARRAY:C911($at_headerName; "Authorization")
		APPEND TO ARRAY:C911($at_headerValue; "Bearer "+$vo_tokenResponse.authResult.token.access_token)
		
		For each ($vo_header; $vc_headers)
			APPEND TO ARRAY:C911($at_headerName; $vo_header.name)
			APPEND TO ARRAY:C911($at_headerValue; $vo_header.value)
		End for each 
		
		//Clear process variables
		vl_httpError:=0
		vt_httpError:=""
		vl_jsonError:=0
		vt_jsonError:=""
		
		ON ERR CALL:C155("HTTP_Error")
		If (Count parameters:C259>5)
			$vl_status:=HTTP Request:C1158($vt_requestType; $vt_url; $v_body; $vt_response; $at_headerName; $at_headerValue)
		Else 
			$vl_status:=HTTP Request:C1158($vt_requestType; $vt_url; ""; $vt_response; $at_headerName; $at_headerValue)
		End if 
		ON ERR CALL:C155("")
		
		$vc_responseHeaders:=New collection:C1472
		ARRAY TO COLLECTION:C1563($vc_responseHeaders; $at_headerName; "name"; $at_headerValue; "value")
		
		$vo_response.url:=$vt_url
		$vo_response.responseHeaders:=$vc_responseHeaders
		If ($vt_authType="auth")
			$vo_response.authResult:=$vo_tokenResponse.authResult
			$vo_response.tokenRefreshed:=$vo_tokenResponse.tokenRefreshed
		End if 
		
		If (vl_httpError#0)
			$vo_response.status:=0
			$vo_response.response:=New object:C1471("errorCode"; vl_httpError; "errorMessage"; vt_httpError)
		Else 
			
			$vo_response.status:=$vl_status
			If ($vt_response#"")
				ON ERR CALL:C155("JSON_Error")
				$vo_response.response:=JSON Parse:C1218($vt_response)
				ON ERR CALL:C155("")
				
				If (vl_jsonError#0)  //Error occured when parsing JSON
					$vo_response.jsonError:=vt_jsonError
					$vo_response.response:=$vt_response
				End if 
			Else 
				$vo_response.response:=New object:C1471
			End if 
		End if 
		
	Else 
		$vo_response.status:=0
		$vo_response.error:=$vo_tokenResponse.error
		If (OB Is defined:C1231($vo_tokenResponse; "response"))
			$vo_response.response:=$vo_tokenResponse.response
		End if 
	End if 
Else 
	$vo_response.status:=0
	$vo_response.error:="Missing mandatory parameters"
End if 

$0:=$vo_response
