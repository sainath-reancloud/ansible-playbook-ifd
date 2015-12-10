
Set-WebConfigurationProperty /system.webServer/security/authentication/windowsAuthentication -Name useAppPoolCredentials -value True -location "Microsoft Dynamics CRM"

Get-WebConfigurationProperty /system.webServer/security/authentication/windowsAuthentication -Name useAppPoolCredentials -location "Microsoft Dynamics CRM"
