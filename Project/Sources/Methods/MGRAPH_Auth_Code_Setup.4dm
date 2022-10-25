//%attributes = {"shared":true}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 03/10/22, 14:55:03
// ----------------------------------------------------
// Method: MGRAPH_Auth_Code_Setup
// Description
// 
//
// Parameters
// $0 - Object - Object containing information required by component to generate access tokens?????
// ----------------------------------------------------

var $0; $vo_response : Object

var $vo_authPrefs; $vo_formData : Object
var $vt_state; $vt_message : Text


$vo_response:=New object:C1471
$vo_response.success:=False:C215

//Check preferences have been setup
If (OB Is defined:C1231(Storage:C1525.prefs; "authorizationCodeSettings"))
	
	//Create non shared copy
	$vo_authPrefs:=OB Copy:C1225(Storage:C1525.prefs.authorizationCodeSettings)
	
	//Ensure all required properties exist
	$vt_message:=UTIL_Check_Mandatory_Props($vo_authPrefs; New collection:C1472("clientId"; "tenantId"; "scope"; "redirectUri"; "baseAuthUrl"; "baseApiUrl"))
	
	If ($vt_message="")
		
		//Random string used to validate response from auth server
		$vt_state:=String:C10(Milliseconds:C459)
		
		$vo_formData:=New object:C1471
		$vo_formData.response:=New object:C1471
		$vo_formData.response.success:=False:C215
		$vo_formData.authorizationCodeSettings:=$vo_authPrefs
		$vo_formData.state:=$vt_state
		$vo_formData.redirectUri:=$vo_authPrefs.redirectUri
		
		$vo_formData.url:=$vo_authPrefs.baseAuthUrl+\
			"?client_id="+$vo_authPrefs.clientId+\
			"&response_type=code"+\
			"&redirect_uri="+$vo_authPrefs.redirectUri+\
			"&response_mode=query"+\
			"&scope="+$vo_authPrefs.scope+\
			"&state="+$vt_state
		
		If (OB Is defined:C1231($vo_authPrefs; "prompt"))
			$vo_formData.url:=$vo_formData.url+"&prompt="+$vo_authPrefs.prompt
		Else 
			$vo_formData.url:=$vo_formData.url+"&prompt=login"
		End if 
		
		
		$vl_SW:=Screen width:C187\2
		$vl_SH:=Screen height:C188\2
		
		FORM GET PROPERTIES:C674("MGRAPH_Auth_Code"; $vl_width; $vl_height)
		
		$vl_WW:=$vl_width\2
		$vl_WH:=$vl_height\2
		
		$vl_window:=Open window:C153($vl_SW-$vl_WW; $vl_SH-$vl_WH; $vl_SW+$vl_WW; $vl_SH+$vl_WH; Plain dialog box:K34:4; "Microsoft Authorization Code Flow")
		DIALOG:C40("MGRAPH_Auth_Code"; $vo_formData)
		CLOSE WINDOW:C154($vl_window)
		
		TRACE:C157
		
		If (OK=1)
			
			If ($vo_formData.response.success)
				//Get access token and return object to host
				
				//tenantId - should be 'common' in this case
				//clientId
				//scope - I believe we need to include 'offline_access' to get a refresh token
				//code - from formdata.response
				//redirect_uri - same as already used
				//grand_type - 'authorization_code'
				//secret
				
				$vo_authParams:=OB Copy:C1225($vo_authPrefs)
				$vo_authParams.code:=$vo_formData.response.code
				
				$vo_response:=MGRAPH_Get_Access_Token("auth"; $vo_authParams)
				
			Else 
				//Return error message to host
				
			End if 
			
		End if 
		
	Else 
		$vo_response.error:=$vt_message
	End if 
Else 
	$vo_response.error:="Authorization Code Settings have not been setup in Preferences"
End if 

$0:=$vo_response
