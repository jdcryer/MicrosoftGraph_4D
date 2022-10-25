<!-- Type your summary here -->
## Description

For use with 'client_credentials' grant flow.

This function adds a client to the component's internal storage for use with other commands.

## Parameters

| Parameter | Type | Detail |
| ----------- | ----------- | ----------- |
| $1 | Text | Azure Application Client ID |
| $2 | Text | Azure Application Tenant ID |
| $3 | Text | Azure Application Client Secret |
| $4 | Text | Grant Type - 'client_credentials' |
| $5 | Text | The Base URL for API Requests |

## Example

```4d
$vt_clientId:=<CLIENT ID>
$vt_tenantId:=<TENANT ID>
$vt_secret:=<CLIENT SECRET>
$vt_grantType:="client_credentials"
$vt_baseUrl:="https://graph.microsoft.com/v1.0/"

MGRAPH_ADD_CLIENT($vt_clientId;$vt_tenantId;$vt_secret;$vt_grantType;$vt_baseUrl)
```
