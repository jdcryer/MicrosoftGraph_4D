//%attributes = {"shared":true,"preemptive":"capable"}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 25/10/22, 09:47:17
// ----------------------------------------------------
// Method: MGRAPH_MIME_To_Extension
// Description
// Converts given MIME Type to file extension
//
// Parameters
// $0 - Text - File Extension
// $1 - Text - Mime Type
// ----------------------------------------------------

var $0; $vt_extension; $1; $vt_mime : Text

var $vl_index : Integer

If (Count parameters:C259>0)
	
	$vt_mime:=$1
	
	$vl_index:=Storage:C1525.fileTypes.findIndex("UTIL_Find_Collection"; "mime"; $vt_mime)
	If ($vl_index>=0)
		$vt_extension:=Storage:C1525.fileTypes[$vl_index].extension
	End if 
	
End if 

$0:=$vt_extension
