//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// User name (OS): Dougie
// Date and time: 07/03/18, 15:33:46
// ----------------------------------------------------
// Method: UTIL_Get_Query_Params
// Description
// Parses the passed URL string to get the query parameters.
//
// Parameters
// $0 - Object - Key/Value object
// $1 - Text   - URL to parse
// ----------------------------------------------------

var $0; $vo_response : Object
var $1 : Text
var $vl_Pos; $i; $vl_PosEquals : Integer

ARRAY TEXT:C222($at_Field; 0)
ARRAY TEXT:C222($at_Value; 0)
ARRAY TEXT:C222($at_KeyPairs; 0)

$vl_Pos:=Position:C15("?"; $1)
If ($vl_Pos>0)
	ARRAY TEXT:C222($at_KeyPairs; 0)
	CSV_PARSE_RECORD(->$at_KeyPairs; Substring:C12($1; ($vl_Pos+1)); 38)
	For ($i; 1; Size of array:C274($at_KeyPairs))
		$vl_PosEquals:=Position:C15("="; $at_KeyPairs{$i})
		If ($vl_PosEquals>0)
			APPEND TO ARRAY:C911($at_Field; Substring:C12($at_KeyPairs{$i}; 1; ($vl_PosEquals-1)))
			APPEND TO ARRAY:C911($at_Value; Substring:C12($at_KeyPairs{$i}; ($vl_PosEquals+1)))
		End if 
	End for 
End if 

$vo_response:=New object:C1471
For ($i; 1; Size of array:C274($at_Field))
	$vo_response[$at_Field{$i}]:=$at_Value{$i}
End for 

$0:=$vo_response
