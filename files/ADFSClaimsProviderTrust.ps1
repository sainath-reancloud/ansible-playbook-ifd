
# UPN Claim
$existingRules = (Get-AdfsClaimsProviderTrust -Name "Active Directory").AcceptanceTransformRules

if(-not($existingRules -match '@RuleName = "UPN Claim Rule"')){
    $updatedRules = $existingRules + '@RuleTemplate = "LdapClaims" @RuleName = "UPN Claim Rule" c:[Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/windowsaccountname", Issuer == "AD AUTHORITY"] => issue(store = "Active Directory", types = ("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn"), query = ";userPrincipalName;{0}", param = c.Value);'
    $crSet = New-ADFSClaimRuleSet -ClaimRule $updatedRules
    Set-ADFSClaimsProviderTrust -TargetName "Active Directory" -AcceptanceTransformRules $crSet.ClaimRulesString
}
