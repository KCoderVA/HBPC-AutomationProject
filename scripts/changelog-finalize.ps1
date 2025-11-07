<#
.SYNOPSIS
  Promote the Unreleased section in CHANGELOG.md to a versioned release and create a matching git tag (optional).

.DESCRIPTION
  Parses CHANGELOG.md, finds '## [Unreleased]' block, renames it to specified version with current date, and inserts a fresh Unreleased placeholder.

.PARAMETER Version
  Semantic version to release (e.g. 0.1.2).

.PARAMETER Tag
  Switch to also create and push a git annotated tag.

.EXAMPLE
  ./scripts/changelog-finalize.ps1 -Version 0.1.2 -Tag

.NOTES
  Assumes CHANGELOG.md uses headings: ## [Unreleased], ## [x.y.z] - YYYY-MM-DD
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$Version,
  [switch]$Tag
)

$ErrorActionPreference = 'Stop'
$changeLogPath = Join-Path $PSScriptRoot '..' 'CHANGELOG.md'
if(!(Test-Path $changeLogPath)){ throw "CHANGELOG.md not found at $changeLogPath" }

$date = (Get-Date).ToString('yyyy-MM-dd')
$content = Get-Content $changeLogPath -Raw

if(-not ($content -match '## \[Unreleased\]')){ throw "Unreleased section not found" }

# Insert new version header
$newHeader = "## [$Version] - $date"

# Replace Unreleased header with new version header
$updated = $content -replace '## \[Unreleased\]', $newHeader

# Add fresh Unreleased placeholder above first version
if($updated -notmatch '## \[Unreleased\]'){ $updated = "## [Unreleased]\n- Pending: Add entries here\n\n" + $updated }

Set-Content -Path $changeLogPath -Value $updated -Encoding UTF8
Write-Host "Promoted Unreleased to version $Version ($date)" -ForegroundColor Green

if($Tag){
  git add $changeLogPath | Out-Null
  git commit -m "chore(changelog): finalize $Version" | Out-Null
  git tag -a "v$Version" -m "v$Version: release" | Out-Null
  Write-Host "Tag v$Version created. Run 'git push --follow-tags' to publish." -ForegroundColor Yellow
}
