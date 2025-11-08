<# SPDX-License-Identifier: Apache-2.0 #>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Get-Location
$srcDir = Join-Path $repoRoot 'src'
if(-not (Test-Path $srcDir)){
    Write-Error "src directory not found at $srcDir"
    exit 1
}

$archivesDir = Join-Path $repoRoot 'archives'
if(-not (Test-Path $archivesDir)) { New-Item -ItemType Directory -Path $archivesDir | Out-Null }

$manifestName = 'src-baseline-manifest-v0.3.0.jsonl'
$manifestPath = Join-Path $archivesDir $manifestName
if(Test-Path $manifestPath){ Remove-Item $manifestPath }

Get-ChildItem -Path $srcDir -File -Recurse | ForEach-Object {
    $hash = Get-FileHash -Algorithm SHA256 -Path $_.FullName
    $relPath = $_.FullName.Substring($repoRoot.Path.Length + 1)
    $obj = [ordered]@{ path = $relPath; size = $_.Length; sha256 = $hash.Hash }
    $json = $obj | ConvertTo-Json -Compress
    Add-Content -Path $manifestPath -Value $json
}

$lineCount = (Get-Content $manifestPath | Measure-Object).Count
Write-Host "Manifest written: $manifestPath ($lineCount entries)"