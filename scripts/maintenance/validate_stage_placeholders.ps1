<#
SPDX-License-Identifier: Apache-2.0
.SYNOPSIS
Reports placeholder counts for each stage's runInfo.json.
.DESCRIPTION
Iterates stage directories under src/flows/HBPC_AdmitsDischarges/stages, parses metadata/runInfo.json, and outputs a table
highlighting any artifacts still marked as placeholders. Useful prior to declaring full migration completion.
#>

$stageRoot = Join-Path $PSScriptRoot '..' '..' 'src' 'flows' 'HBPC_AdmitsDischarges' 'stages'
$stageRoot = (Resolve-Path $stageRoot).Path

$results = @()
Get-ChildItem -Path $stageRoot -Directory | ForEach-Object {
    $stageDir = $_.FullName
    $runInfoPath = Join-Path $stageDir 'metadata' 'runInfo.json'
    if (-not (Test-Path $runInfoPath)) { return }
    try {
        $json = Get-Content $runInfoPath -Raw | ConvertFrom-Json
    } catch {
        Write-Warning "Failed to parse JSON: $runInfoPath"
        return
    }
    $placeholders = @()
    if ($json.placeholders) { $placeholders += $json.placeholders }
    if ($json.artifacts) {
        $json.artifacts.psobject.Properties | ForEach-Object {
            $val = $_.Value
            if ($val -is [System.Collections.Hashtable]) {
                if ($val.ContainsKey('placeholder') -and $val.placeholder) {
                    $placeholders += $val.file
                }
            } elseif ($val -is [Object]) {
                # deep objects (reports, commits) may contain nested hashtables
                $val.psobject.Properties | ForEach-Object {
                    $nested = $_.Value
                    if ($nested -is [System.Collections.Hashtable]) {
                        if ($nested.ContainsKey('placeholder') -and $nested.placeholder) {
                            $placeholders += $nested.file
                        }
                    }
                }
            }
        }
    }
    $results += [PSCustomObject]@{
        Stage = $json.stage
        Status = $json.status
        PlaceholderCount = $placeholders.Count
        PlaceholderFiles = if($placeholders.Count -gt 0){ $placeholders -join '; ' } else { '' }
    }
}

$results | Sort-Object Stage | Format-Table -AutoSize

# Exit code logic: 0 if all stages have zero placeholders; 1 otherwise.
if (($results | Where-Object { $_.PlaceholderCount -gt 0 }).Count -eq 0) { exit 0 } else { exit 1 }
