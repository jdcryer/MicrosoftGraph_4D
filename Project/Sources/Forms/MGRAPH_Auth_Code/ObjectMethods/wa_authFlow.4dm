
MGRAPH_AUTH_CODE_FORM_EVENT(FORM Event:C1606)

Case of 
	: (Form event code:C388=On Begin URL Loading:K2:45) | (Form event code:C388=On URL Loading Error:K2:48)
		$vt_url:=WA Get current URL:C1025(*; "wa_authFlow")
		
		//Need to test the url somehow?
		
		If ($vt_url="")
			
			
			
			
		End if 
		
End case 
