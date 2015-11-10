# "https" "REC40CRM.greatvalleyu.com" "REC40CRM.greatvalleyu.com" "REC40CRM.greatvalleyu.com" "CRMDEPLOY.greatvalleyu.com" "true"
param
(
    #optional params
    [string]$crmUser,
    [string]$crmUserPassword,
    [string]$DwsServerUrl,
    [string]$RootDomainScheme,
    [string]$WebAppRootDomain,
    [string]$SdkRootDomain,
    [string]$DiscoveryRootDomain,
    [string]$DeploymentSdkRootDomain,
    [string]$NlbEnabled,
    [string]$SslHeader
)

$AccountPasswordAsSecureString = $crmUserPassword | ConvertTo-SecureString -Force -AsPlainText
$credential = New-Object System.Management.Automation.PsCredential($crmUser,$AccountPasswordAsSecureString)

if($NlbEnabled -eq "true"){
    $NlbEnabled = $true
}
else{
    $NlbEnabled = $false
}

Add-PSSnapin Microsoft.Crm.PowerShell

$WebAddressSettings = Get-CrmSetting -SettingType WebAddressSettings -DwsServerUrl $DwsServerUrl -Credential $credential

if($DeploymentSdkRootDomain) {$WebAddressSettings.DeploymentSdkRootDomain = $DeploymentSdkRootDomain}
if($DiscoveryRootDomain) {$WebAddressSettings.DiscoveryRootDomain = $DiscoveryRootDomain}
$WebAddressSettings.NlbEnabled = $NlbEnabled
if($RootDomainScheme) {$WebAddressSettings.RootDomainScheme = $RootDomainScheme}
if($SdkRootDomain) {$WebAddressSettings.SdkRootDomain = $SdkRootDomain}
if($PSBoundParameters.ContainsKey('SslHeader')) {$WebAddressSettings.SslHeader = $SslHeader}
if($WebAppRootDomain) {$WebAddressSettings.WebAppRootDomain = $WebAppRootDomain}

Set-CrmSetting -Setting $WebAddressSettings -DwsServerUrl $DwsServerUrl -Credential $credential

$WebAddressSettings
