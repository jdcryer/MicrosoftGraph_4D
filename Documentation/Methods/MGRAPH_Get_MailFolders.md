<!-- Type your summary here -->
## Description

Gets one or multiple Mail Folders.

See [MS documentation](https://learn.microsoft.com/en-us/graph/api/resources/mailfolder?view=graph-rest-1.0) on the mailFolder resource for details regarding query parameters / response properties etc.

## Parameters

$0 - Object

| Property | Type | Detail |
| ----------- | ----------- | ----------- |
| status | Integer | HTTP Status returned by the server. Will equal 0 if the component encountered an issue before posting the request |
| | | ***Available only if the component has encountered an issue, and therefore not sent a request*** |
| error | String | Error message detailing an issue with given parameters |
| | | ***Available only if a request was sent*** |
| response | Object | Response received from the server, check MS documentation linked above for details of object properties |
| responseHeaders | Collection | Headers return by server in a collection of objects with the format { name: string, value: string } |
| url | String | The request URL sent to the server for audit/logging purposes |

$1 - Object

| Property | Mandatory | Type | Detail |
| ----------- | ----------- | ----------- | ----------- |
| clientId | Y | String | Client ID of the account to use |
| userId | N | String | User ID / userPrincipalName of the user to get the mail folder from, if omitted a '/me/mailFolders' request is sent |
| mailFolderId | N | String | Mail Folder ID to get one details for one folder |
| queryParams | N | Collection | Collection of objects with the format { name: string, value: string } to include in request URL |



## Example

List all mail folders for a given user:

```4d
var $vo_parameters; $vo_response; $vo_mailFolder : Object

$vo_parameters:=New object
$vo_parameters.clientId:=<CLIENT ID>
$vo_parameters.userId:=<USER ID>

$vo_response:=MGRAPH_Get_MailFolders($vo_parameters)

For each($vo_mailFolder;$vo_response.response.value)
	//Do Something...
End for each
```

Get the details of one mail folder using its ID:

```4d
var $vo_parameters; $vo_response; $vo_mailFolder : Object

$vo_parameters:=New object
$vo_parameters.clientId:=<CLIENT ID>
$vo_parameters.userId:=<USER ID>
$vo_parameters.mailFolderId:=<MAILFOLDER ID>

$vo_response:=MGRAPH_Get_MailFolders($vo_parameters)

$vo_mailFolder:=$vo_response.response.value
```
