//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 29/09/22, 11:06:52
// ----------------------------------------------------
// Method: MGRAPH_ADD_CLIENT
// Description
// 
//
// Parameters
// $1 - String - Client ID
// $2 - String - Tenant ID
// $3 - String - Secret
// $4 - String - Grant type
// $5 - String - Base URL
// ----------------------------------------------------

var $1; $2; $3; $4 : Text
var $vo_client : Object

If (Count parameters:C259>3)
	$vo_client:=New shared object:C1526
	Use ($vo_client)
		$vo_client.clientId:=$1
		$vo_client.tenantId:=$2
		$vo_client.secret:=$3
		$vo_client.grantType:=$4
		$vo_client.baseUrl:=$5
	End use 
	
	$vl_index:=Storage:C1525.clients.findIndex("UTIL_Find_Collection"; "clientId"; $1)
	Use (Storage:C1525.clients)
		If ($vl_index=-1)
			Storage:C1525.clients.push($vo_client)
		Else 
			Storage:C1525.clients[$vl_index]:=$vo_client
		End if 
	End use 
	
End if 
