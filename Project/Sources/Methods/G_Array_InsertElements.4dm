//%attributes = {"invisible":true,"preemptive":"capable"}
//********************************************************************************
//* Procedure: G_Array_InsertElements
//* Description:  inserts into all arrays listed in parameters 3 onwards
//*              the number of elements stated in parameter 2 at point parameter 1
//*              If parameter 1 is 0 (zero) it will insert the new rows at the end
//*              of the arrays
//* Called from: Any proc requiring to do multiple insert lines into arrays
//*   ~ 
//* Parameters:
//*   ~ $1 - Start point for insert
//*   ~ $2 - No if rows to insert
//*   ~ $3>-Arrays to insert rows into
//* Procedures called:
//*   ~ 
//* Layouts used:
//*   ~ 
//* Externals used:
//*   ~ 
//* Written by: Mehdi Shariatzadeh (Zadeh designs) & J Douglas Cryer (Telekinetix)
//* Date written: 14/1/97
//********************************************************************************
//* Modified date: 
//* Modifed by: 
//* Description: 
//********************************************************************************

C_LONGINT:C283($1; $2; $vl_Pos; $0)
C_POINTER:C301(${3})

If ($1=0)  //If you want the elements added to the end
	$vl_Pos:=Size of array:C274($3->)+1
Else 
	$vl_Pos:=$1
End if 

For ($i; 3; Count parameters:C259)  //got through the arrays
	INSERT IN ARRAY:C227(${$i}->; $vl_Pos; $2)  //and add the elements at point $1
End for 

$0:=$vl_Pos