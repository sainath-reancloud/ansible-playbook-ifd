# "CERT:\LocalMachine\My" "*"

param(    
    [string]$CertPath,
    [string]$CertWildCard
)

$Name = "Microsoft Dynamics CRM"
$IPAddress = "*"

$ErrorActionPreference = "Stop";

Import-Module WebAdministration

$sslCertificate = gci $CertPath | Where-Object { $_.Subject -ilike $CertWildCard }
if (-not $sslCertificate) {
	Throw "Cannot find SSL certificate for $Name, cannot configure HTTPS... Installed Certificates are:"
	gci CERT:\LocalMachine\My | ft
}


New-WebBinding -Name $Name -IPAddress $ipAddress -Port 443 -Protocol https -Force
New-Item -Path "IIS:\SslBindings\$IPAddress!443" -Value $sslCertificate

Get-WebBinding -Port 80 -Name $Name | Remove-WebBinding

iisreset



