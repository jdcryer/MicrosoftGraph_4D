//%attributes = {"shared":true,"preemptive":"capable"}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 30/09/22, 10:15:17
// ----------------------------------------------------
// Method: MGRAPH_Get_Messages
// Description
// 
//
// Parameters
// $0 - Object - Response
// $1 - Object - { clientId?: string, authParams?: object, queryParams?: collection, userId?: string, mailFolderId?: string } 
// ----------------------------------------------------

var $0; $vo_response; $1; $vo_params : Object

var $vt_endpoint : Text
var $vc_params : Collection

$vo_response:=New object:C1471

If (Count parameters:C259>0)
	$vo_params:=$1
	
	
	If ((OB Is defined:C1231($vo_params; "clientId")) | (OB Is defined:C1231($vo_params; "authParams")))
		
		If (OB Is defined:C1231($vo_params; "userId"))
			If (OB Is defined:C1231($vo_params; "mailFolderId"))
				$vt_endpoint:="users/"+$vo_params.userId+"/mailFolders/"+$vo_params.mailFolderId+"/messages"
			Else 
				$vt_endpoint:="users/"+$vo_params.userId+"/messages"
			End if 
		Else 
			If (OB Is defined:C1231($vo_params; "mailFolderId"))
				$vt_endpoint:="me/mailFolders/"+$vo_params.mailFolderId+"/messages"
			Else 
				$vt_endpoint:="me/messages"
			End if 
		End if 
		
		$vc_params:=New collection:C1472
		If (OB Is defined:C1231($vo_params; "queryParams"))
			$vc_params:=$vo_params.queryParams
		End if 
		
		If (OB Is defined:C1231($vo_params; "clientId"))
			$vo_response:=MGRAPH_Make_Request($vo_params.clientId; $vt_endpoint; HTTP GET method:K71:1; $vc_params)
		Else 
			$vo_response:=MGRAPH_Make_Request($vo_params.authParams; $vt_endpoint; HTTP GET method:K71:1; $vc_params)
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
