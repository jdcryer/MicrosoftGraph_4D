//%attributes = {"shared":true,"preemptive":"capable"}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 30/09/22, 13:31:44
// ----------------------------------------------------
// Method: MGRAPH_Post_Send_Mail
// Description
// 
//
// Parameters
// $0 - Object - Response
// $1 - Object - params { clientId?: string, authParams?: object, userId: string, body: object / string, type: string }
// ----------------------------------------------------

var $0; $vo_response; $1; $vo_params : Object

var $vt_endpoint; $vt_base64; $vt_message; $vt_messageId; $vt_range; $vt_uploadUrl : Text
var $vc_headers; $vc_separateAttachments : Collection
var $vx_attachment; $vx_streamResponse; $vx_tempBlob : Blob
var $vo_attachment; $vo_draftResponse; $vo_sendResponse; $vo_streamResponse; \
$vo_tempAuthResult; $vo_uploadResponse : Object
var $i; $vl_bytesToCopy; $vl_maxPacket; $vl_size; $vl_sourceOffset; $vl_status; $vl_subLength : Integer
var $vb_break; $vb_sendMessage : Boolean

$vo_response:=New object:C1471

$vl_maxPacket:=3145728

If (Count parameters:C259>0)
	$vo_params:=$1
	
	If ((OB Is defined:C1231($vo_params; "clientId")) | (OB Is defined:C1231($vo_params; "authParams")))
		
		$vt_message:=UTIL_Check_Mandatory_Props($vo_params; New collection:C1472("body"; "type"))
		
		If ($vt_message="")
			
			//Check request for attachments.
			//If trying to send files of > 3MB, these files must be sent in separate octet-stream request
			If ($vo_params.type="application/json")
				$vc_separateAttachments:=New collection:C1472
				
				If (OB Is defined:C1231($vo_params.body.message; "attachments"))
					
					For ($i; $vo_params.body.message.attachments.length-1; 0; -1)
						$vo_attachment:=$vo_params.body.message.attachments[$i]
						
						$vt_base64:=$vo_attachment.contentBytes
						BASE64 DECODE:C896($vt_base64; $vx_attachment)
						
						$vl_size:=BLOB size:C605($vx_attachment)
						
						If ($vl_size>=3145728)
							$vc_separateAttachments.push(OB Copy:C1225($vo_attachment))
							
							$vo_params.body.message.attachments.remove($i)
						End if 
						
					End for 
					
				End if 
			End if 
			
			If ($vc_separateAttachments.length>0)
				
				//As we have separate attachments to process, first create a draft message using the post body
				
				If ($vo_params.body.message.attachments.length=0)
					OB REMOVE:C1226($vo_params.body.message; "attachments")
				End if 
				
				If (OB Is defined:C1231($vo_params; "userId"))
					$vt_endpoint:="users/"+$vo_params.userId+"/messages"
				Else 
					$vt_endpoint:="me/messages"
				End if 
				
				$vc_headers:=New collection:C1472
				$vc_headers.push(New object:C1471("name"; "Content-Type"; "value"; $vo_params.type))
				
				If (OB Is defined:C1231($vo_params; "clientId"))
					$vo_draftResponse:=MGRAPH_Make_Request($vo_params.clientId; $vt_endpoint; HTTP POST method:K71:2; New collection:C1472; $vc_headers; $vo_params.body.message)
				Else 
					$vo_draftResponse:=MGRAPH_Make_Request($vo_params.authParams; $vt_endpoint; HTTP POST method:K71:2; New collection:C1472; $vc_headers; $vo_params.body.message)
					If ($vo_draftResponse.status=201)
						$vo_tempAuthResult:=$vo_draftResponse.authResult
					End if 
				End if 
				
				If ($vo_draftResponse.status=201)
					$vt_messageId:=$vo_draftResponse.response.id
					
					//Using message ID, create uploadStream for each attachment
					
					For each ($vo_attachment; $vc_separateAttachments)
						
						$vt_base64:=$vo_attachment.contentBytes
						BASE64 DECODE:C896($vt_base64; $vx_attachment)
						
						$vl_size:=BLOB size:C605($vx_attachment)
						
						$vo_sessionBody:=New object:C1471
						$vo_sessionBody.AttachmentItem:=New object:C1471
						$vo_sessionBody.AttachmentItem.attachmentType:="file"
						$vo_sessionBody.AttachmentItem.name:=$vo_attachment.name
						$vo_sessionBody.AttachmentItem.size:=$vl_size
						
						If (OB Is defined:C1231($vo_params; "userId"))
							$vt_endpoint:="users/"+$vo_params.userId+"/messages/"+$vt_messageId+"/attachments/createUploadSession"
						Else 
							$vt_endpoint:="me/messages/"+$vt_messageId+"/attachments/createUploadSession"
						End if 
						
						If (OB Is defined:C1231($vo_params; "clientId"))
							$vo_uploadResponse:=MGRAPH_Make_Request($vo_params.clientId; $vt_endpoint; HTTP POST method:K71:2; New collection:C1472; $vc_headers; $vo_sessionBody)
						Else 
							$vo_uploadResponse:=MGRAPH_Make_Request($vo_tempAuthResult; $vt_endpoint; HTTP POST method:K71:2; New collection:C1472; $vc_headers; $vo_sessionBody)
							If ($vo_uploadResponse.status=201)
								$vo_tempAuthResult:=$vo_uploadResponse.authResult
							End if 
						End if 
						
						If ($vo_uploadResponse.status=201)
							
							$vt_uploadUrl:=$vo_uploadResponse.response.uploadUrl
							
							$vl_sourceOffset:=0
							$vl_bytesToCopy:=0
							
							$vb_break:=False:C215
							Repeat 
								
								//Upload attachment in chuncks of 3MB (3145728)
								CLEAR VARIABLE:C89($vx_tempBlob)
								
								$vl_subLength:=0
								$vt_range:=""
								
								If (($vl_size-$vl_sourceOffset)>$vl_maxPacket)
									$vl_bytesToCopy:=$vl_maxPacket
								Else 
									$vl_bytesToCopy:=($vl_size-$vl_sourceOffset)
								End if 
								
								COPY BLOB:C558($vx_attachment; $vx_tempBlob; $vl_sourceOffset; 0; $vl_bytesToCopy)
								
								$vl_subLength:=BLOB size:C605($vx_tempBlob)
								$vt_range:="bytes "+String:C10($vl_sourceOffset)+"-"+String:C10(($vl_sourceOffset+$vl_bytesToCopy)-1)+"/"+String:C10($vl_size)
								
								$vl_sourceOffset:=$vl_sourceOffset+$vl_bytesToCopy
								
								ARRAY TEXT:C222($at_header; 0)
								ARRAY TEXT:C222($at_value; 0)
								
								APPEND TO ARRAY:C911($at_header; "Content-Type")
								APPEND TO ARRAY:C911($at_value; "application/octet-stream")
								
								APPEND TO ARRAY:C911($at_header; "Content-Length")
								APPEND TO ARRAY:C911($at_value; String:C10($vl_subLength))
								
								APPEND TO ARRAY:C911($at_header; "Content-Range")
								APPEND TO ARRAY:C911($at_value; $vt_range)
								
								$vl_status:=HTTP Request:C1158(HTTP PUT method:K71:6; $vt_uploadUrl; $vx_tempBlob; $vo_streamResponse; $at_header; $at_value)
								
								If ($vl_status=201)  //201 is the end of the file...
									$vb_break:=True:C214
									$vb_sendMessage:=True:C214
								Else 
									$vb_break:=($vl_status#200)
									$vb_break:=$vb_break | (($vl_size-$vl_sourceOffset)<=0)
								End if 
								
							Until ($vb_break)
							
						End if 
						
					End for each 
					
					If ($vb_sendMessage)
						
						If (OB Is defined:C1231($vo_params; "userId"))
							$vt_endpoint:="users/"+$vo_params.userId+"/messages/"+$vt_messageId+"/send"
						Else 
							$vt_endpoint:="me/messages/"+$vt_messageId+"/send"
						End if 
						
						If (OB Is defined:C1231($vo_params; "clientId"))
							$vo_sendResponse:=MGRAPH_Make_Request($vo_params.clientId; $vt_endpoint; HTTP POST method:K71:2; New collection:C1472; $vc_headers)
						Else 
							$vo_sendResponse:=MGRAPH_Make_Request($vo_tempAuthResult; $vt_endpoint; HTTP POST method:K71:2; New collection:C1472; $vc_headers)
							If ($vo_sendResponse.status=201)
								$vo_tempAuthResult:=$vo_sendResponse.authResult
							End if 
						End if 
						
					Else 
						//Delete the draft message?
					End if 
					
				End if 
				
			Else 
				
				If (OB Is defined:C1231($vo_params; "userId"))
					$vt_endpoint:="users/"+$vo_params.userId+"/sendMail"
				Else 
					$vt_endpoint:="me/sendMail"
				End if 
				
				$vc_headers:=New collection:C1472
				$vc_headers.push(New object:C1471("name"; "Content-Type"; "value"; $vo_params.type))
				
				If (OB Is defined:C1231($vo_params; "clientId"))
					$vo_response:=MGRAPH_Make_Request($vo_params.clientId; $vt_endpoint; HTTP POST method:K71:2; New collection:C1472; $vc_headers; $vo_params.body)
				Else 
					$vo_response:=MGRAPH_Make_Request($vo_params.authParams; $vt_endpoint; HTTP POST method:K71:2; New collection:C1472; $vc_headers; $vo_params.body)
				End if 
			End if 
			
		Else 
			$vo_response.status:=0
			$vo_response.error:=$vt_message
		End if 
	Else 
		$vo_response.status:=0
		$vo_response.error:="You must provide either clientId or authParams"
	End if 
Else 
	$vo_response.status:=0
	$vo_response.error:="Mandatory parameter $1 not passed"
End if 

$0:=$vo_response
