//%attributes = {"invisible":true,"preemptive":"capable"}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 09/09/22, 09:14:09
// ----------------------------------------------------
// Method: MGRAPH_Get_Access_Token
// Description
// Checks stored access token for given application Id ?
//
// Parameters
// $0 - Object  - { success: boolean, access_token?: string, error?: string, response?: object }
// $1 - String  - Auth type
// $2 - Variant - Application Id or Object containing auth details
// ----------------------------------------------------

var $0; $vo_methodResponse : Object
var $1; $vt_type; $vt_clientId : Text
var $2 : Variant

var $vb_getToken; $vb_tokenOK; $vb_refresh : Boolean
var $vt_body; $vt_response; $vt_timestamp; $vt_url; vt_httpError; $vt_timestampCompare : Text
var $vl_index; $vl_status; vl_httpError : Integer
var $vd_date : Date
var $vh_newTime; $vh_tempTime : Time
var $vo_client; $vo_response : Object

$vo_methodResponse:=New object:C1471
$vo_methodResponse.success:=False:C215

//Clear process variables
vt_httpError:=""
vl_httpError:=0

If (Count parameters:C259>1)
	$vt_type:=$1
	If ($vt_type="client")
		$vt_clientId:=$2
		$vl_index:=Storage:C1525.clients.findIndex("UTIL_Find_Collection"; "clientId"; $vt_clientId)
		If ($vl_index>=0)
			$vo_client:=Storage:C1525.clients[$vl_index]
		Else 
			$vo_methodResponse.error:="Client ID not found"
		End if 
	Else 
		$vo_client:=$2
	End if 
	
	//Check we have a token / is still valid
	If (OB Is defined:C1231($vo_client; "token"))
		
		$vt_timestampCompare:=String:C10(Current date:C33; ISO date:K1:8; Current time:C178)
		
		If ($vt_timestampCompare>$vo_client.token.expiresAt)
			$vb_getToken:=True:C214
			$vb_refresh:=True:C214
		Else 
			$vb_tokenOK:=True:C214
		End if 
		
	Else 
		$vb_getToken:=True:C214
	End if 
	
	If ($vb_getToken)
		
		ARRAY TEXT:C222($at_headerName; 0)
		ARRAY TEXT:C222($at_headerValue; 0)
		
		APPEND TO ARRAY:C911($at_headerName; "Content-Type")
		APPEND TO ARRAY:C911($at_headerValue; "application/x-www-form-urlencoded")
		
		Case of 
			: ($vt_type="client")
				$vt_body:="client_id="+$vo_client.clientId+\
					"&scope=https://graph.microsoft.com/.default"+\
					"&client_secret="+$vo_client.secret+\
					"&grant_type="+$vo_client.grantType
				
			: (($vt_type="auth") & ($vb_refresh))
				$vt_body:="client_id="+$vo_client.clientId+\
					"&scope="+$vo_client.scope+\
					"&refresh_token="+$vo_client.token.refresh_token+\
					"&grant_type=refresh_token"
				
			: ($vt_type="auth")
				$vt_body:="client_id="+$vo_client.clientId+\
					"&scope="+$vo_client.scope+\
					"&code="+$vo_client.code+\
					"&redirect_uri="+$vo_client.redirectUri+\
					"&grant_type=authorization_code"
				
		End case 
		
		$vt_url:="https://login.microsoftonline.com/"+$vo_client.tenantId+"/oauth2/v2.0/token"
		
		ON ERR CALL:C155("HTTP_Error")
		$vl_status:=HTTP Request:C1158(HTTP POST method:K71:2; $vt_url; $vt_body; $vt_response; $at_headerName; $at_headerValue)
		
		$vo_response:=JSON Parse:C1218($vt_response)
		ON ERR CALL:C155("")
		
		If (vl_httpError#0)
			$vo_methodResponse.status:=0
			$vo_methodResponse.response:=New object:C1471("errorCode"; vl_httpError; "errorMessage"; vt_httpError; "response"; $vt_response)
			
		Else 
			If ($vl_status=200)
				//Update storage with new token
				$vb_tokenOK:=True:C214
				
				
				$vd_date:=Current date:C33(*)
				$vh_tempTime:=Current time:C178(*)
				
				//Access tokens are actually valid for 60 mins
				$vh_newTime:=$vh_tempTime+?00:50:00?
				If ($vh_newTime>?24:00:00?)
					$vh_newTime:=$vh_newTime-?24:00:00?
					$vd_date:=Add to date:C393($vd_date; 0; 0; 1)
				End if 
				
				$vt_timestamp:=String:C10($vd_date; ISO date:K1:8; $vh_newTime)
				
				$vo_response.expiresAt:=$vt_timestamp
				If ($vt_type="client")
					Use (Storage:C1525.clients[$vl_index])
						Storage:C1525.clients[$vl_index].token:=OB Copy:C1225($vo_response; ck shared:K85:29)
					End use 
				Else 
					$vo_client.token:=OB Copy:C1225($vo_response)
				End if 
				
			Else 
				$vo_methodResponse.error:="Failed to obtain new Acccess Token"
				$vo_methodResponse.response:=New object:C1471
				$vo_methodResponse.response.request:=$vt_body
				$vo_methodResponse.response.response:=$vo_response
			End if 
		End if 
		
	End if 
	
	If ($vb_tokenOK)
		$vo_methodResponse.success:=True:C214
		If ($vt_type="client")
			$vo_methodResponse.authResult:=OB Copy:C1225(Storage:C1525.clients[$vl_index])
		Else 
			$vo_methodResponse.authResult:=$vo_client
			$vo_methodResponse.tokenRefreshed:=$vb_refresh
		End if 
	End if 
	
Else 
	$vo_methodResponse.error:="Required parameters not passed"
End if 
$0:=$vo_methodResponse
