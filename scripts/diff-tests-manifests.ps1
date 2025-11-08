<# SPDX-License-Identifier: Apache-2.0 #>
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$repoRoot=Get-Location
$archives=Join-Path $repoRoot 'archives'
$oldPath=Join-Path $archives 'tests-old-manifest.jsonl'
$newPath=Join-Path $archives 'tests-new-manifest.jsonl'
if(-not (Test-Path $oldPath)){ Write-Error 'Old tests manifest missing'; exit 1 }
if(-not (Test-Path $newPath)){ Write-Warning 'No new tests manifest (tests folder absent) -> All old tests considered removed';
  $old=(Get-Content $oldPath | ForEach-Object { $_ | ConvertFrom-Json })
  $mdPath=Join-Path $archives 'TESTS_DIFF_v0.3.0_to_REPLACEMENT.md'
  $sb=New-Object System.Text.StringBuilder
  $null=$sb.AppendLine('# Tests Diff v0.3.0 -> Replacement')
  $null=$sb.AppendLine()
  $null=$sb.AppendLine('Summary:')
  $null=$sb.AppendLine("- Added: 0")
  $null=$sb.AppendLine("- Removed: $($old.Count)")
  $null=$sb.AppendLine("- Modified: 0")
  $null=$sb.AppendLine("- Unchanged: 0")
  $null=$sb.AppendLine()
  $null=$sb.AppendLine('## Removed Files')
  $null=$sb.AppendLine('path | size | sha256')
  $null=$sb.AppendLine('--- | --- | ---')
  foreach($i in $old){ $null=$sb.AppendLine("$($i.path) | $($i.size) | $($i.sha256)") }
  $sb.ToString() | Out-File -FilePath $mdPath -Encoding UTF8
  Write-Host "Tests diff written (only removals): $mdPath"; exit 0 }
$old=(Get-Content $oldPath | ForEach-Object { $_ | ConvertFrom-Json })
$new=(Get-Content $newPath | ForEach-Object { $_ | ConvertFrom-Json })
$oldMap=@{}; foreach($o in $old){ $oldMap[$o.path]=$o }
$newMap=@{}; foreach($n in $new){ $newMap[$n.path]=$n }
$added=@(); $removed=@(); $modified=@(); $unchanged=@()
foreach($k in $oldMap.Keys){
  if(-not $newMap.ContainsKey($k)){
    $removed+=$oldMap[$k]
  } else {
    if($oldMap[$k].sha256 -ne $newMap[$k].sha256){
      $modified+=[pscustomobject]@{ path=$k; oldSize=$oldMap[$k].size; newSize=$newMap[$k].size; oldSha=$oldMap[$k].sha256; newSha=$newMap[$k].sha256 }
    } else {
      $unchanged+=$oldMap[$k]
    }
  }
}
foreach($k in $newMap.Keys){
  if(-not $oldMap.ContainsKey($k)){
    $added+=$newMap[$k]
  }
}
$mdPath=Join-Path $archives 'TESTS_DIFF_v0.3.0_to_REPLACEMENT.md'
$sb=New-Object System.Text.StringBuilder
$null=$sb.AppendLine('# Tests Diff v0.3.0 -> Replacement')
$null=$sb.AppendLine()
$null=$sb.AppendLine('Summary:')
$null=$sb.AppendLine("- Added: $($added.Count)")
$null=$sb.AppendLine("- Removed: $($removed.Count)")
$null=$sb.AppendLine("- Modified: $($modified.Count)")
$null=$sb.AppendLine("- Unchanged: $($unchanged.Count)")
$null=$sb.AppendLine()
function Add-Table($title,$items,$cols){
  $null=$sb.AppendLine("## $title")
  if($items.Count -eq 0){ $null=$sb.AppendLine('None') } else {
    $header=$cols -join ' | '
    $null=$sb.AppendLine($header)
    $null=$sb.AppendLine(($cols | ForEach-Object { '---' }) -join ' | ')
    foreach($i in $items){ $row=@(); foreach($c in $cols){ $row+=($i.$c) }; $null=$sb.AppendLine(($row -join ' | ')) }
  }
  $null=$sb.AppendLine()
}
Add-Table 'Added Files' $added @('path','size','sha256')
Add-Table 'Removed Files' $removed @('path','size','sha256')
Add-Table 'Modified Files' $modified @('path','oldSize','newSize','oldSha','newSha')
$sb.ToString() | Out-File -FilePath $mdPath -Encoding UTF8
Write-Host "Tests diff written: $mdPath (added=$($added.Count) removed=$($removed.Count) modified=$($modified.Count) unchanged=$($unchanged.Count))"