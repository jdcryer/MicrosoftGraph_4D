//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 10/10/22, 10:05:52
// ----------------------------------------------------
// Method: MGRAPH_AUTH_CODE_FORM_EVENT
// Description
// 
//
// Parameters
// $1 - Object - Form event object
// ----------------------------------------------------

var $1; $vo_formEvent : Object

$vo_formEvent:=$1

If (Not:C34(OB Is defined:C1231($vo_formEvent; "objectName")))
	$vo_formEvent.objectName:="form"
End if 

Case of 
	: ($vo_formEvent.objectName="form")
		
		Case of 
			: ($vo_formEvent.code=On Load:K2:1)
				
				WA OPEN URL:C1020(*; "wa_authFlow"; Form:C1466.url)
				
		End case 
		
	: ($vo_formEvent.objectName="wa_authFlow")
		
		Case of 
			: (($vo_formEvent.code=On URL Loading Error:K2:48) | ($vo_formEvent.code=On End URL Loading:K2:47))
				
				var $vt_url : Text
				
				$vt_url:=WA Get current URL:C1025(*; "wa_authFlow")
				
				If ($vt_url=(Form:C1466.redirectUri+"@"))
					
					//Parse query params
					$vo_params:=UTIL_Get_Query_Params($vt_url)
					
					If ((OB Is defined:C1231($vo_params; "code")) & (OB Is defined:C1231($vo_params; "state")))
						//Validate state is the expected value
						
						If ($vo_params.state=Form:C1466.state)
							
							Form:C1466.response.success:=True:C214
							Form:C1466.response.code:=$vo_params.code
							
							ACCEPT:C269
							
						Else 
							
							Form:C1466.response.error:="Mismatch on returned 'State' value"
							
							ACCEPT:C269
							
						End if 
						
					Else 
						TRACE:C157
						
						//Check params for error message to return
						
						
					End if 
					
				End if 
				
		End case 
		
End case 

