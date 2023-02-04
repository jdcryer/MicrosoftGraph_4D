//%attributes = {"shared":true,"preemptive":"capable"}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 17/10/22, 16:26:52
// ----------------------------------------------------
// Method: MGRAPH_Delete_Message
// Description
// 
//
// Parameters
// $0 - Object - Response
// $1 - Object - { messageId: string, clientId?: string, authParams?: object, userId?: string, mailFolderId?: string } 
// ----------------------------------------------------

var $0; $vo_response; $1; $vo_params : Object

var $vt_endpoint : Text

$vo_response:=New object:C1471

If (Count parameters:C259>0)
	$vo_params:=$1
	
	If (OB Is defined:C1231($vo_params; "messageId"))
		If ((OB Is defined:C1231($vo_params; "clientId")) | (OB Is defined:C1231($vo_params; "authParams")))
			
			If (OB Is defined:C1231($vo_params; "userId"))
				If (OB Is defined:C1231($vo_params; "mailFolderId"))
					$vt_endpoint:="users/"+$vo_params.userId+"/mailFolders/"+$vo_params.mailFolderId+"/messages/"+$vo_params.messageId
				Else 
					$vt_endpoint:="users/"+$vo_params.userId+"/messages/"+$vo_params.messageId
				End if 
			Else 
				If (OB Is defined:C1231($vo_params; "mailFolderId"))
					$vt_endpoint:="me/mailFolders/"+$vo_params.mailFolderId+"/messages/"+$vo_params.messageId
				Else 
					$vt_endpoint:="me/messages/"+$vo_params.messageId
				End if 
			End if 
			
			If (OB Is defined:C1231($vo_params; "clientId"))
				$vo_response:=MGRAPH_Make_Request($vo_params.clientId; $vt_endpoint; HTTP DELETE method:K71:5)
			Else 
				$vo_response:=MGRAPH_Make_Request($vo_params.authParams; $vt_endpoint; HTTP DELETE method:K71:5)
			End if 
			
		Else 
			$vo_response.status:=0
			$vo_response.error:="You must provide either clientId or authParams"
		End if 
	Else 
		$vo_response.status:=0
		$vo_response.error:="You must provide a messageId"
	End if 
Else 
	$vo_response.status:=0
	$vo_response.error:="Mandatory parameter $1 not passed"
End if 

$0:=$vo_response
