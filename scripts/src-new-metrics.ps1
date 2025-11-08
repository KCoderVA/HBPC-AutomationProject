Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$repoRoot=Get-Location
$srcDir=Join-Path $repoRoot 'src'
if(-not (Test-Path $srcDir)){ Write-Error 'src missing'; exit 1 }
$archives=Join-Path $repoRoot 'archives'
$outPath=Join-Path $archives 'src-new-metrics-after-replacement.json'

$files=Get-ChildItem -Path $srcDir -File -Recurse
$totalBytes=($files | Measure-Object -Property Length -Sum).Sum
$extGroups=$files | Group-Object Extension | ForEach-Object { [pscustomobject]@{ extension=$_.Name; count=$_.Count; bytes=(($_.Group|Measure-Object -Property Length -Sum).Sum) } }
$textExt=@('.html','.json','.md','.txt','.ts','.ps1','.yml','.yaml','.py','.css','.js','.tsx')
$lineAgg=@{}
foreach($f in $files){ if($textExt -contains $f.Extension){ try { $lc=(Get-Content -Path $f.FullName | Measure-Object -Line).Lines; if(-not $lineAgg.ContainsKey($f.Extension)){ $lineAgg[$f.Extension]=0 }; $lineAgg[$f.Extension]+=$lc } catch { Write-Warning "Line count failed $($f.FullName): $($_.Exception.Message)" } } }
$linesPerExtension=$lineAgg.GetEnumerator() | Sort-Object Name | ForEach-Object { [pscustomobject]@{ extension=$_.Key; lines=$_.Value } }
$metrics=[ordered]@{ timestamp=(Get-Date).ToString('o'); versionTag='REPLACEMENT'; fileCount=$files.Count; totalBytes=$totalBytes; extensions=$extGroups; linesPerExtension=$linesPerExtension }
$metrics | ConvertTo-Json -Depth 6 | Out-File -FilePath $outPath -Encoding UTF8
Write-Host "New src metrics written: $outPath (files=$($files.Count) bytes=$totalBytes)"