//%attributes = {"shared":true}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 30/09/22, 13:35:26
// ----------------------------------------------------
// Method: MGRAPH_Get_Next
// Description
// 
//
// Parameters
// $0 - Object - Response
// $1 - Object - Params { clientId?: string, authParams?: object, url: string }
// ----------------------------------------------------

var $0; $vo_response; $1; $vo_params : Object

var $vl_status; $vl_index : Integer
var $vt_url; $vt_response; $vt_message : Text
var $vo_tokenResponse : Object
var $vc_responseHeaders : Collection

var vl_httpError; vl_jsonError : Integer
var vt_httpError; vt_jsonError : Text

ARRAY TEXT:C222($at_headerName; 0)
ARRAY TEXT:C222($at_headerValue; 0)

$vo_response:=New object:C1471

If (Count parameters:C259>0)
	$vo_params:=$1
	
	If ((OB Is defined:C1231($vo_params; "clientId")) | (OB Is defined:C1231($vo_params; "authParams")))
		
		$vt_message:=UTIL_Check_Mandatory_Props($vo_params; New collection:C1472("url"))
		
		If ($vt_message="")
			If (OB Is defined:C1231($vo_params; "clientId"))
				$vo_tokenResponse:=MGRAPH_Get_Access_Token("client"; $vo_params.clientId)
			Else 
				$vo_tokenResponse:=MGRAPH_Get_Access_Token("auth"; $vo_params.authParams)
			End if 
			If ($vo_tokenResponse.success)
				
				APPEND TO ARRAY:C911($at_headerName; "Authorization")
				APPEND TO ARRAY:C911($at_headerValue; "Bearer "+$vo_tokenResponse.authResult.token.access_token)
				
				ON ERR CALL:C155("HTTP_Error")
				$vt_url:=$vo_params.url
				$vl_status:=HTTP Request:C1158(HTTP GET method:K71:1; $vt_url; ""; $vt_response; $at_headerName; $at_headerValue)
				ON ERR CALL:C155("")
				
				$vc_responseHeaders:=New collection:C1472
				ARRAY TO COLLECTION:C1563($vc_responseHeaders; $at_headerName; "name"; $at_headerValue; "value")
				
				$vo_response.url:=$vt_url
				$vo_response.responseHeaders:=$vc_responseHeaders
				If (OB Is defined:C1231($vo_params; "authParams"))
					$vo_response.authResult:=$vo_tokenResponse.authResult
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
			End if 
		Else 
			$vo_response.status:=0
			$vo_response.error:=$vt_message
		End if 
	Else 
		$vo_response.status:=0
		$vo_response.error:="You must provide either clientId or authParams"
	End if 
Else 
	$vo_response.status:=0
	$vo_response.error:="Mandatory parameter $1 not passed"
End if 

$0:=$vo_response
