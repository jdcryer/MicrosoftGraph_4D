//%attributes = {"shared":true}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 25/10/22, 09:39:48
// ----------------------------------------------------
// Method: MGRAPH_Extension_To_MIME
// Description
// Converts given file extension to MIME Type
//
// Parameters
// $0 - Text - MIME Type
// $1 - Text - File extension
// ----------------------------------------------------

var $0; $vt_mime; $1; $vt_extension : Text

var $vl_index : Integer

If (Count parameters:C259>0)
	$vt_extension:=$1
	
	If (Not:C34($vt_extension=".@"))
		$vt_extension:="."+$vt_extension
	End if 
	
	$vl_index:=Storage:C1525.fileTypes.findIndex("UTIL_Find_Collection"; "extension"; $vt_extension)
	If ($vl_index>=0)
		$vt_mime:=Storage:C1525.fileTypes[$vl_index].mime
	End if 
	
End if 

$0:=$vt_mime
