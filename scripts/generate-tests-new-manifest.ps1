<# SPDX-License-Identifier: Apache-2.0 #>
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$repoRoot=Get-Location
$newTests=Join-Path $repoRoot 'tests'
if(-not (Test-Path $newTests)){ Write-Warning 'No new tests directory present'; exit 0 }
$out=Join-Path (Join-Path $repoRoot 'archives') 'tests-new-manifest.jsonl'
if(Test-Path $out){ Remove-Item $out }
Get-ChildItem -Path $newTests -File -Recurse | ForEach-Object {
  $hash=Get-FileHash -Algorithm SHA256 -Path $_.FullName
  $rel=$_.FullName.Substring($repoRoot.Path.Length+1)
  $obj=[ordered]@{ path=$rel; size=$_.Length; sha256=$hash.Hash }
  ($obj|ConvertTo-Json -Compress)|Add-Content -Path $out
}
$lines=(Get-Content $out | Measure-Object).Count
Write-Host "New tests manifest: $out ($lines entries)"