Param(
    [string]$FederationURL_Internal,
    [string]$FederationURL_External,
)

$FederationURL_Internal = $FederationURL_Internal + "/FederationMetadata/2007-06/FederationMetadata.xml"

$FederationURL_External = $FederationURL_External + "/FederationMetadata/2007-06/FederationMetadata.xml"

Add-ADFSRelyingPartyTrust -Name "CRMRelyingTrust" -AutoUpdateEnabled $true -MonitoringEnabled $true -MetadataUrl $FederationURL_Internal -IssuanceAuthorizationRules '@RuleTemplate = "AllowAllAuthzRule" => issue(Type = "http://schemas.microsoft.com/authorization/claims/permit", Value = "true");' -IssuanceTransformRules '@RuleTemplate = "PassThroughClaims" @RuleName = "Pass Through UPN" c:[Type == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn"] => issue(claim = c); @RuleTemplate = "PassThroughClaims" @RuleName = "Pass Through Primary SID" c:[Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/primarysid"] => issue(claim = c); @RuleTemplate = "MapClaims" @RuleName = "Transform Windows Account Name to Name" c:[Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/windowsaccountname"] => issue(Type = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name", Issuer = c.Issuer, OriginalIssuer = c.OriginalIssuer, Value = c.Value, ValueType = c.ValueType);'

Add-ADFSRelyingPartyTrust -Name "AuthRelyingTrust" -AutoUpdateEnabled $true -MonitoringEnabled $true -MetadataUrl $FederationURL_External -IssuanceAuthorizationRules '@RuleTemplate = "AllowAllAuthzRule" => issue(Type = "http://schemas.microsoft.com/authorization/claims/permit", Value = "true");' -IssuanceTransformRules '@RuleTemplate = "PassThroughClaims" @RuleName = "Pass Through UPN" c:[Type == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn"] => issue(claim = c); @RuleTemplate = "PassThroughClaims" @RuleName = "Pass Through Primary SID" c:[Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/primarysid"] => issue(claim = c); @RuleTemplate = "MapClaims" @RuleName = "Transform Windows Account Name to Name" c:[Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/windowsaccountname"] => issue(Type = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name", Issuer = c.Issuer, OriginalIssuer = c.OriginalIssuer, Value = c.Value, ValueType = c.ValueType);'
