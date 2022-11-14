//%attributes = {"invisible":true}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 30/09/22, 14:22:39
// ----------------------------------------------------
// Method: UTIL_Check_Mandatory_Props
// Description
// Checks given object for given list of mandatory properties,
// returns error message listing missing props
// Parameters
// $0 - Text       - Error message, blank if all props found
// $1 - Object     - Ob to check
// $2 - Collection - List of properties to look for
// ----------------------------------------------------

var $0; $vt_message : Text
var $1; $vo_object : Object
var $2; $vc_properties : Collection

var $vt_prop : Text
var $vc_missing : Collection

$vo_object:=$1
$vc_properties:=$2
$vc_missing:=New collection:C1472

For each ($vt_prop; $vc_properties)
	If (Not:C34(OB Is defined:C1231($vo_object; $vt_prop)))
		$vc_missing.push($vt_prop)
	End if 
End for each 

If ($vc_missing.length>0)
	$vt_message:="Missing mandatory properties: "+$vc_missing.join(", ")
End if 

$0:=$vt_message
