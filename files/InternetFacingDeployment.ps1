Param(
    [string]$crmUser,
    [string]$crmUserPassword,
    [string]$DwsServerUrl,
    [string]$WebApplicationRootDomain,
    [string]$OrganizationWebServiceRootDomain,
    [string]$DiscoveryWebServiceRootDomain,
    [string]$ExternalDomain
)

$AccountPasswordAsSecureString = $crmUserPassword | ConvertTo-SecureString -Force -AsPlainText
$credential = New-Object System.Management.Automation.PsCredential($crmUser,$AccountPasswordAsSecureString)

Add-PSSnapin Microsoft.Crm.PowerShell

$IfdSettings = Get-CrmSetting -SettingType IfdSettings -DwsServerUrl $DwsServerUrl -Credential $credential

$IfdSettings.Enabled = $true

if($DiscoveryWebServiceRootDomain) {$IfdSettings.DiscoveryWebServiceRootDomain = $DiscoveryWebServiceRootDomain}
if($ExternalDomain) {$IfdSettings.ExternalDomain = $ExternalDomain}
if($OrganizationWebServiceRootDomain) {$IfdSettings.OrganizationWebServiceRootDomain = $OrganizationWebServiceRootDomain}
if($WebApplicationRootDomain) {$IfdSettings.WebApplicationRootDomain = $WebApplicationRootDomain}

Set-CrmSetting -Setting $IfdSettings -DwsServerUrl $DwsServerUrl -Credential $credential

$IfdSettings
