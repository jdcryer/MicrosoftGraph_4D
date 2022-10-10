//%attributes = {}
//Method: CSV_PARSE_RECORD
//Written by: J. Douglas Cryer
//Date: 25/1/2005
//Parses a CSV record into an array.
//Takes into account quote protected comma or other separator characters.
C_POINTER:C301($1)
C_TEXT:C284($2; $vt_CurFld; $vt_InText)
C_LONGINT:C283($3)
C_LONGINT:C283($vl_Count; $vl_Len; $i; $vl_SOA; $vl_End; $vl_Start)
C_TEXT:C284($vs_FldSep)
If (Count parameters:C259=3)
	$vs_FldSep:=Char:C90($3)
Else 
	$vs_FldSep:=Char:C90(44)  // default to comma
End if 
$vl_SOA:=Size of array:C274($1->)
$vt_InText:=$2
$vl_Count:=0
If ($vt_InText#"")
	If (Substring:C12($vt_InText; Length:C16($vt_InText))=$vs_FldSep)  //If the last field is empty
		$vt_InText:=$vt_InText+$vs_FldSep  //we must add a field seperator
	End if   //Otherwise the last field will not be read.
	Repeat 
		$vl_Start:=1
		$vl_Count:=$vl_Count+1
		If ($vl_Count>$vl_SOA)
			$vl_SOA:=G_Array_InsertElements(0; 1; $1)
		End if 
		If ($vt_InText[[$vl_Start]]=Char:C90(34))  // If it is a quote then look for next quote/comma.
			$vl_End:=Position:C15(Char:C90(34)+$vs_FldSep; $vt_InText)
			If ($vl_End=0)
				$vl_End:=Length:C16($vt_InText)
			End if 
			$vl_Len:=$vl_End-($vl_Start+1)
			$vl_End:=$vl_End+2
			$vl_Start:=$vl_Start+1
		Else   // It is not a quote so look for the next seperator.
			$vl_End:=Position:C15($vs_FldSep; $vt_InText)
			If ($vl_End=0)
				$vl_End:=Length:C16($vt_InText)+1
			End if 
			$vl_Len:=$vl_End-$vl_Start
			$vl_End:=$vl_End+1
		End if 
		//Now strip out the double quotes if present.
		$1->{$vl_Count}:=Replace string:C233(Substring:C12($vt_InText; $vl_Start; $vl_Len); Char:C90(34); "")
		$vt_InText:=Substring:C12($vt_InText; $vl_End)
	Until ($vt_InText="")
End if 
