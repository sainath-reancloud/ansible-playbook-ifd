Param(
    [string]$FederationURL,
    [string]$TrustName
)

$FederationURL = $FederationURL + "/FederationMetadata/2007-06/FederationMetadata.xml"

$relyingTrust = Get-AdfsRelyingPartyTrust -Name $TrustName

if($relyingTrust -ne $null){
    Remove-AdfsRelyingPartyTrust -TargetName $TrustName
}

Add-ADFSRelyingPartyTrust -Name $TrustName -AutoUpdateEnabled $true -MonitoringEnabled $true -MetadataUrl $FederationURL -IssuanceAuthorizationRules '@RuleTemplate = "AllowAllAuthzRule" => issue(Type = "http://schemas.microsoft.com/authorization/claims/permit", Value = "true");' -IssuanceTransformRules '@RuleTemplate = "PassThroughClaims" @RuleName = "Pass Through UPN" c:[Type == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn"] => issue(claim = c); @RuleTemplate = "PassThroughClaims" @RuleName = "Pass Through Primary SID" c:[Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/primarysid"] => issue(claim = c); @RuleTemplate = "MapClaims" @RuleName = "Transform Windows Account Name to Name" c:[Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/windowsaccountname"] => issue(Type = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name", Issuer = c.Issuer, OriginalIssuer = c.OriginalIssuer, Value = c.Value, ValueType = c.ValueType);'

Set-ADFSRelyingPartyTrust -Targetname $TrustName -TokenLifetime 480
