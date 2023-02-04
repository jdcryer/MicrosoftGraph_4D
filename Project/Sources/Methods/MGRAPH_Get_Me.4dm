//%attributes = {"shared":true,"preemptive":"capable"}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 25/10/22, 16:32:37
// ----------------------------------------------------
// Method: MGRAPH_Get_Me
// Description
// 
//
// Parameters
// $0 - Object - Response
// $1 - Object - { authParams: object, queryParams?: collection } 
// ----------------------------------------------------

var $0; $vo_response; $1; $vo_params : Object

var $vt_endpoint : Text
var $vc_params : Collection

$vo_response:=New object:C1471

If (Count parameters:C259>0)
	$vo_params:=$1
	
	If (OB Is defined:C1231($vo_params; "authParams"))
		
		$vt_endpoint:="me"
		
		$vc_params:=New collection:C1472
		If (OB Is defined:C1231($vo_params; "queryParams"))
			$vc_params:=$vo_params.queryParams
		End if 
		
		$vo_response:=MGRAPH_Make_Request($vo_params.authParams; $vt_endpoint; HTTP GET method:K71:1; $vc_params)
		
	Else 
		$vo_response.status:=0
		$vo_response.error:="You must provide authParams"
	End if 
Else 
	$vo_response.status:=0
	$vo_response.error:="Mandatory parameter $1 not passed"
End if 

$0:=$vo_response
