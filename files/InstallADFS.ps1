Param (
[String]$domain,
[string]$runAsUser,
[string]$runAsPassword,
[string]$adfsDisplayName
)

#requires -version 4 
<# 
.SYNOPSIS 
   Installs ADFS role and configure it for Ellucian eCRM product
  
 .DESCRIPTION 
   Installs ADFS 3.0 server role in Windows 2012 R2, configures it for domain greatvalleyu.com for eCRM POD automation 
  
.NOTES 
   Version:        1.0 
   Author:         Sajjad Ahmed 
   Creation Date:  9/30/2015 
   Purpose/Change: ADFS installation using Powershell and Terraform
#>

#Script Version 
$sScriptVersion = "1.0" 

#Script Path
$sScriptRoot = "C:\Installers"

################################### Execution ##################################

# Retrieving credentials for domain user which will be used to create ADFS Farm

$password = $runAsPassword | ConvertTo-SecureString -asPlainText -Force
$username = $runAsUser 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)

$session = New-PSSession -Credential $credential

Install-windowsfeature adfs-federation -IncludeManagementTools

#Check if ADFS role is installed
Get-WindowsFeature ADFS-Federation

Invoke-Command -Session $session -ScriptBlock {
    Param (
        [String]$domain,
        [string]$runAsUser,
        [string]$runAsPassword,
        [string]$adfsDisplayName
    )

    $sFedService = "adfs.$domain"
    # Create ADFS Farm
    Write-Host "Adding ADFS Farm: $sFedService"

    $sThumbprint = (Get-ChildItem -Path Cert:\LocalMachine\my | Where-Object {$_.Subject -match "$domain"}).Thumbprint
    Write-Host -Object "My thumbprint is: $sThumbprint"

    $password = $runAsPassword | ConvertTo-SecureString -asPlainText -Force
    $username = $runAsUser 
    $credential = New-Object System.Management.Automation.PSCredential($username,$password)

    $session = New-PSSession -Credential $credential

    Import-Module ADFS
    Install-AdfsFarm -CertificateThumbprint $sThumbprint -FederationServiceName $sFedService -FederationServiceDisplayName $adfsDisplayName -ServiceAccountCredential $credential -Credential $credential

    Start-Sleep -Seconds 120
    Restart-Service "Active Directory Federation Services"

    Write-Host "ADFS Installation is complete"

} -ArgumentList @($domain,$runAsUser,$runAsPassword,$adfsDisplayName)



