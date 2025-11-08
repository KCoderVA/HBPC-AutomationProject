Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$repoRoot=Get-Location
$srcDir=Join-Path $repoRoot 'src'
if(-not (Test-Path $srcDir)){ Write-Error 'New src directory missing'; exit 1 }
$archives=Join-Path $repoRoot 'archives'
$newName='src-new-manifest-after-replacement.jsonl'
$newPath=Join-Path $archives $newName
if(Test-Path $newPath){ Remove-Item $newPath }
Get-ChildItem -Path $srcDir -File -Recurse | ForEach-Object {
  $hash=Get-FileHash -Algorithm SHA256 -Path $_.FullName
  $rel=$_.FullName.Substring($repoRoot.Path.Length+1)
  $obj=[ordered]@{ path=$rel; size=$_.Length; sha256=$hash.Hash }
  ($obj | ConvertTo-Json -Compress) | Add-Content -Path $newPath
}
$lines=(Get-Content $newPath | Measure-Object).Count
Write-Host "New manifest written: $newPath ($lines entries)"