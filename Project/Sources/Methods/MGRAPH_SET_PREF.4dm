//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 03/10/22, 14:11:07
// ----------------------------------------------------
// Method: MGRAPH_SET_PREF
// Description
// 
//
// Parameters
// $1 - String  - Pref Name
// $2 - Variant - Preference Value
// ----------------------------------------------------

var $1; $vt_pref : Text
var $2; $v_value : Variant

If (Count parameters:C259>1)
	
	$vt_pref:=$1
	$v_value:=$2
	
	Use (Storage:C1525.prefs)
		
		Case of 
			: (Value type:C1509($v_value)=Is object:K8:27)
				Storage:C1525.prefs[$vt_pref]:=OB Copy:C1225($v_value; ck shared:K85:29)
				
			: (Value type:C1509($v_value)=Is collection:K8:32)
				Storage:C1525.prefs[$vt_pref]:=$v_value.copy(ck shared:K85:29)
				
			Else 
				Storage:C1525.prefs[$vt_pref]:=$v_value
				
		End case 
		
	End use 
	
End if 
