Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$repoRoot = Get-Location
$srcDir = Join-Path $repoRoot 'src'
if(-not (Test-Path $srcDir)) { Write-Error "src directory missing"; exit 1 }
$archivesDir = Join-Path $repoRoot 'archives'
if(-not (Test-Path $archivesDir)) { New-Item -ItemType Directory -Path $archivesDir | Out-Null }

$files = Get-ChildItem -Path $srcDir -File -Recurse
if($files.Count -eq 0){ Write-Warning 'No files under src'; exit 0 }

$totalBytes = ($files | Measure-Object -Property Length -Sum).Sum
$extGroups = $files | Group-Object Extension | ForEach-Object {
    $bytes = ($_.Group | Measure-Object -Property Length -Sum).Sum
    [pscustomobject]@{
        extension = if([string]::IsNullOrEmpty($_.Name)) { '' } else { $_.Name }
        count     = $_.Count
        bytes     = $bytes
    }
}

$textExt = @('.html','.json','.md','.txt')
$lineAgg = @{}
foreach($f in $files){
    if($textExt -contains $f.Extension){
        try {
            $lc = (Get-Content -Path $f.FullName | Measure-Object -Line).Lines
            if(-not $lineAgg.ContainsKey($f.Extension)){ $lineAgg[$f.Extension] = 0 }
            $lineAgg[$f.Extension] += $lc
        } catch {
            Write-Warning "Failed line count for $($f.FullName): $($_.Exception.Message)"
        }
    }
}
$linesPerExtension = $lineAgg.GetEnumerator() | Sort-Object Name | ForEach-Object { [pscustomobject]@{ extension=$_.Key; lines=$_.Value } }

$metrics = [ordered]@{
    timestamp = (Get-Date).ToString('o')
    versionTag = 'v0.3.0'
    fileCount = $files.Count
    totalBytes = $totalBytes
    extensions = $extGroups
    linesPerExtension = $linesPerExtension
}

$metricsPath = Join-Path $archivesDir 'src-baseline-metrics-v0.3.0.json'
$metrics | ConvertTo-Json -Depth 5 | Out-File -FilePath $metricsPath -Encoding UTF8

Write-Host "Metrics written: $metricsPath"
Write-Host "File count: $($files.Count)  Total bytes: $totalBytes"
Write-Host 'By extension:'
$extGroups | Sort-Object bytes -Descending | Format-Table -AutoSize | Out-String | Write-Host
Write-Host 'Lines per extension:'
$linesPerExtension | Format-Table -AutoSize | Out-String | Write-Host