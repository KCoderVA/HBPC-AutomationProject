<#
SPDX-License-Identifier: Apache-2.0
.SYNOPSIS
Computes stable content hash of GOVERNANCE.md excluding policy version marker.
.DESCRIPTION
Utility script retained for manual hash recalculation if governance materially changes.
#>
$raw = Get-Content -Raw "governance/GOVERNANCE.md"
$contentSans = $raw -replace '<!-- POLICY-VERSION:START -->.*?<!-- POLICY-VERSION:END -->',''
$sha256 = [System.BitConverter]::ToString([System.Security.Cryptography.SHA256]::Create().ComputeHash([Text.Encoding]::UTF8.GetBytes($contentSans))).Replace('-','').ToLower()
Write-Host "GOVERNANCE_SHA256=$sha256"