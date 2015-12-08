param (
    [string]$crmUser,
    [string]$crmUserPassword,
    [string]$DwsServerUrl,
    [string]$Certificate,
    [string]$FederationURL
)

$FederationURL = $FederationURL + "/FederationMetadata/2007-06/FederationMetadata.xml"

$AccountPasswordAsSecureString = $crmUserPassword | ConvertTo-SecureString -Force -AsPlainText
$credential = New-Object System.Management.Automation.PsCredential($crmUser,$AccountPasswordAsSecureString)

Add-PSSnapin Microsoft.Crm.PowerShell 

$claims = Get-CrmSetting -SettingType "ClaimsSettings" -DwsServerUrl $DwsServerUrl -Credential $credential
$claims.Enabled = $true

$CertName = (Get-ChildItem -Path Cert:\LocalMachine\my | Where-Object {$_.Subject -match "$Certificate"}).SubjectName.Name

$claims.EncryptionCertificate = $CertName
$claims.FederationMetadataUrl = $FederationURL

Set-CrmSetting $claims -DwsServerUrl $DwsServerUrl -Credential $credential

$claims
