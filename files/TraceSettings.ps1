# "https" "REC40CRM.greatvalleyu.com" "REC40CRM.greatvalleyu.com" "REC40CRM.greatvalleyu.com" "CRMDEPLOY.greatvalleyu.com" "true"
param
(
    #optional params
    [string]$crmUser,
    [string]$crmUserPassword,
    [string]$DwsServerUrl,
    [string]$TraceEnabled,
    [string]$CallStack,
    [string]$Categories,
    [string]$Directory,
    [string]$FileSize
)

$AccountPasswordAsSecureString = $crmUserPassword | ConvertTo-SecureString -Force -AsPlainText
$credential = New-Object System.Management.Automation.PsCredential($crmUser,$AccountPasswordAsSecureString)

if($TraceEnabled -eq "true"){
    $TraceEnabled = $true
}
else{
    $TraceEnabled= $false
}

if($CallStack -eq "true"){
    $CallStack = $true
}
else{
    $CallStack= $false
}

[int]$FileSize = [convert]::ToInt32($FileSize, 10)

Add-PSSnapin Microsoft.Crm.PowerShell

$TraceSettings = Get-CrmSetting -SettingType TraceSettings -DwsServerUrl $DwsServerUrl -Credential $credential

$TraceSettings.Enabled = $TraceEnabled
$TraceSettings.CallStack = $CallStack
if($Categories) {$TraceSettings.Categories = $Categories}
if($Directory) {$TraceSettings.Directory = $Directory}
if($FileSize) {$TraceSettings.FileSize = $FileSize}

Set-CrmSetting -Setting $TraceSettings -DwsServerUrl $DwsServerUrl -Credential $credential

$TraceSettings
