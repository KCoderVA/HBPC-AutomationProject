Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$repoRoot=Get-Location
$oldTests=Join-Path $repoRoot 'archives/tests'
if(-not (Test-Path $oldTests)){ Write-Error 'archives/tests not found'; exit 1 }
$out=Join-Path (Join-Path $repoRoot 'archives') 'tests-old-manifest.jsonl'
if(Test-Path $out){ Remove-Item $out }
Get-ChildItem -Path $oldTests -File -Recurse | ForEach-Object {
  $hash=Get-FileHash -Algorithm SHA256 -Path $_.FullName
  $rel=$_.FullName.Substring($repoRoot.Path.Length+1)
  $obj=[ordered]@{ path=$rel; size=$_.Length; sha256=$hash.Hash }
  ($obj|ConvertTo-Json -Compress)|Add-Content -Path $out
}
$lines=(Get-Content $out | Measure-Object).Count
Write-Host "Old tests manifest: $out ($lines entries)"