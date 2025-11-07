<#
  Purpose: Lightweight local replication of critical CI audit checks for faster contributor feedback.
  Usage:
    pwsh ./scripts/local-ci-audit.ps1 [-FixReadme] [-Verbose]

  Performs (non-destructive unless -FixReadme):
    1. fieldSchema.json structural validation against fieldSchema.schema.json
    2. README badge schema field count verification (optionally auto-fix)
    3. Build info block refresh (commit/date/tag metrics) when -FixReadme supplied
    4. Governance policy version hash diff preview
    5. Presence checks: badge SVG, artifact table required rows, DOC_INDEX freshness

  Exit codes:
    0 = all mandatory checks passed
    1 = structural or fatal errors
    2 = non-fatal warnings only (watch list)

  SPDX-License-Identifier: Apache-2.0
#>
param(
  [switch]$FixReadme,
  [switch]$Verbose
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Info($msg){ Write-Host "[INFO] $msg" }
function Write-Warn($msg){ Write-Warning "[WARN] $msg" }
function Write-Fatal($msg){ Write-Error "[FATAL] $msg" }

$fatal = @()
$warn  = @()

# 1. Schema validation
$schemaPath = 'config/fieldSchema.json'
$schemaSpec = 'config/fieldSchema.schema.json'
if(!(Test-Path $schemaPath)){ Write-Fatal 'fieldSchema.json missing'; $fatal += 'schema-missing' } else {
  try { $schemaJson = Get-Content $schemaPath -Raw | ConvertFrom-Json } catch { Write-Fatal 'Invalid JSON in fieldSchema.json'; $fatal += 'schema-json' }
  if($schemaJson){
    if(-not $schemaJson.fields){ Write-Fatal 'fields array absent'; $fatal += 'schema-no-fields' }
    if(Test-Path $schemaSpec){
      try { $spec = Get-Content $schemaSpec -Raw | ConvertFrom-Json } catch { Write-Warn 'JSON Schema spec parse failed'; $warn += 'schema-spec-json' }
      # Manual enforcement of required fields (subset)
      foreach($f in $schemaJson.fields){
        foreach($req in 'internalName','displayLabel','dataType','fallback'){
          if([string]::IsNullOrWhiteSpace($f.$req)){
            $fatal += ('schema-missing-{0}:{1}' -f $req,$f.internalName)
            Write-Fatal ("Field missing {0}: {1}" -f $req, ($f | ConvertTo-Json -Compress))
          }
        }
        if($f.sensitivity -and $f.sensitivity -notin @('Low','Moderate','High')){
          $warn += ('invalid-sensitivity:{0}' -f $f.internalName)
          Write-Warn "Invalid sensitivity value: $($f.sensitivity)"
        }
      }
    }
    $dup = $schemaJson.fields | Group-Object internalName | Where-Object Count -gt 1 | ForEach-Object Name
    if($dup){ $fatal += 'duplicate-internalName'; Write-Fatal "Duplicate internalName(s): $($dup -join ', ')" }
  }
}

# 2. README badge count
$readme = if(Test-Path 'README.md'){ Get-Content README.md -Raw } else { $fatal += 'readme-missing'; '' }
if($readme){
  if($readme -notmatch '<!-- BADGES:START -->'){ $fatal += 'badges-marker-missing'; Write-Fatal 'Badge marker block missing' }
  elseif($schemaJson){
    $schemaCount = $schemaJson.fields.Count
    $m = [regex]::Match($readme,'Schema Fields:\s*(\d+)')
    if($m.Success){
      $current = [int]$m.Groups[1].Value
      if($current -ne $schemaCount){
        if($FixReadme){
          $updated = [regex]::Replace($readme,'Schema Fields:\s*\d+','Schema Fields: ' + $schemaCount)
          if($updated -ne $readme){ Set-Content README.md -Value $updated -Encoding UTF8; Write-Info "Updated README badge: $current -> $schemaCount" }
        } else { $warn += 'badge-outdated'; Write-Warn "Badge outdated ($current vs $schemaCount); run with -FixReadme to update." }
      } else { Write-Info "Badge count matches schema ($schemaCount)" }
    } else { $fatal += 'badge-count-missing'; Write-Fatal 'Could not parse Schema Fields count in README' }
  }
}

# 3. Build info refresh (optional)
if($FixReadme -and $readme -match '<!-- BUILDINFO:START -->'){
  $shortSha = (git rev-parse --short HEAD).Trim()
  $utcDate  = (Get-Date).ToUniversalTime().ToString('yyyy-MM-dd')
  $lastTag = (git tag --list 'v*' --sort=-creatordate | Select-Object -First 1)
  if([string]::IsNullOrWhiteSpace($lastTag)){ $lastTag = 'none' }
  if($lastTag -eq 'none'){ $commitsSince = (git rev-list --count HEAD); $filesSince = (git ls-files | Measure-Object | ForEach-Object Count) } else { $commitsSince = (git rev-list --count "$lastTag..HEAD"); $filesSince = (git diff --name-only $lastTag HEAD | Measure-Object | ForEach-Object Count) }
  $schemaCount = if($schemaJson){ $schemaJson.fields.Count } else { 0 }
  $newBlock = "<!-- BUILDINFO:START --><div><em>Build Info</em>: Commit <code>$shortSha</code> • UTC <code>$utcDate</code> • Last Tag <code>$lastTag</code> • Commits Since Tag <code>$commitsSince</code> • Files Since Tag <code>$filesSince</code> • Schema Fields Snapshot <code>$schemaCount</code></div><!-- BUILDINFO:END -->"
  $patched = [regex]::Replace($readme,'<!-- BUILDINFO:START -->.*?<!-- BUILDINFO:END -->',$newBlock,'Singleline')
  if($patched -ne $readme){ Set-Content README.md -Value $patched -Encoding UTF8; Write-Info 'Refreshed BUILDINFO block' }
}

# 4. Governance policy hash diff preview
$govPath = 'governance/GOVERNANCE.md'
if(Test-Path $govPath){
  $graw = Get-Content $govPath -Raw
  if($graw -match '<!-- POLICY-VERSION:START -->'){ 
    $marker = [regex]::Match($graw,'<!-- POLICY-VERSION:START -->.*?<!-- POLICY-VERSION:END -->').Value
    $verMatch = [regex]::Match($marker,'Policy Version: (\d+).*?hash: ([0-9a-f]+)')
    if($verMatch.Success){
      $currentHash = $verMatch.Groups[2].Value
      $sans = [regex]::Replace($graw,'<!-- POLICY-VERSION:START -->.*?<!-- POLICY-VERSION:END -->','')
      $bytes = [System.Text.Encoding]::UTF8.GetBytes($sans)
      $newHash = [System.BitConverter]::ToString((New-Object System.Security.Cryptography.SHA256Managed).ComputeHash($bytes)).Replace('-','').ToLower()
      if($newHash -ne $currentHash){ Write-Warn "Governance content changed; hash diff detected (stored=$currentHash new=$newHash). Version will bump in CI." } else { Write-Info 'Governance hash stable.' }
    }
  } else { $warn += 'gov-marker-missing'; Write-Warn 'Governance policy marker block missing' }
} else { $warn += 'gov-missing'; Write-Warn 'governance/GOVERNANCE.md missing' }

# 5. Presence checks
if(!(Test-Path 'assets/badges/schema-field-count.svg')){ $warn += 'badge-svg-missing'; Write-Warn 'Badge SVG absent (expected after release workflow).'}

# Artifact table sanity (robust parsing using markers)
if($readme){
  $match = [regex]::Match($readme,'<!-- ARTIFACT-TABLE:START -->(?<block>[\s\S]*?)<!-- ARTIFACT-TABLE:END -->')
  if($match.Success){
    $block = $match.Groups['block'].Value
    $rows = ($block -split "`n") | Where-Object { $_ -match '^\| `.+` \| `.+` \|' }
    $map = @{}
    foreach($r in $rows){
      $m = [regex]::Match($r,'^\| `([^`]+)` \| `([^`]+)` \|')
      if($m.Success){ $map[$m.Groups[1].Value] = $m.Groups[2].Value }
    }
    foreach($f in 'GOVERNANCE.md','CONTRIBUTING.md','SECURITY.md','RELEASE.md','LABELS.md'){
      if(-not $map.ContainsKey($f) -or $map[$f] -ne 'governance/'){
        $warn += "table-missing-$f"; Write-Warn "$f row missing or incorrect location in artifact table"
      }
    }
  } else {
    $warn += 'artifact-table-missing-markers'; Write-Warn 'Artifact table markers absent'
  }
}

# DOC_INDEX freshness (warn if older than 2 days)
$docIndex = 'docs/DOC_INDEX.md'
if(Test-Path $docIndex){
  $ageDays = ((Get-Date) - (Get-Item $docIndex).LastWriteTimeUtc).TotalDays
  if($ageDays -gt 2){ $warn += 'doc-index-stale'; Write-Warn "DOC_INDEX.md appears stale ($([math]::Round($ageDays,2)) days)" } else { Write-Info 'DOC_INDEX.md freshness OK' }
}

if($fatal.Count -gt 0){ Write-Host "\nSUMMARY: Fatal issues:`n - $($fatal -join "`n - ")"; exit 1 }
elseif($warn.Count -gt 0){ Write-Host "\nSUMMARY: Warnings:`n - $($warn -join "`n - ")"; exit 2 }
else { Write-Info 'All checks passed'; exit 0 }
