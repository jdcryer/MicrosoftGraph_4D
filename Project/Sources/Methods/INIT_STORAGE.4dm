//%attributes = {"invisible":true}

Use (Storage:C1525)
	
	Storage:C1525.clients:=New shared collection:C1527
	
	Storage:C1525.prefs:=New shared object:C1526
	
	Storage:C1525.fileTypes:=New shared collection:C1527
	
	$vt_file:=Get 4D folder:C485(Current resources folder:K5:16)+"fileTypes.json"
	If (Test path name:C476($vt_file)=Is a document:K24:1)
		$vt_content:=Document to text:C1236($vt_file)
		$vo_content:=JSON Parse:C1218($vt_content)
		Use (Storage:C1525.fileTypes)
			Storage:C1525.fileTypes:=$vo_content.fileTypes.copy(ck shared:K85:29)
		End use 
	End if 
	
End use 
