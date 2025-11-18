<#
SPDX-License-Identifier: Apache-2.0
.SYNOPSIS
Lists (and optionally deletes) root artifacts that have verified staged equivalents.
.DESCRIPTION
Reads diff_staged_vs_root.ps1 output logic (recomputes internally) and prepares a deletion plan.
Use -ExecuteCleanup to perform removal; otherwise just lists candidates.
#>
[CmdletBinding()]
param(
  [switch]$ExecuteCleanup
)

$root = (Get-Location).Path
$stageRoot = Join-Path $root 'src\\flows\\HBPC_AdmitsDischarges\\stages'

$mapping = @(
    @{ RootPattern = 'test5_partialSuccess_Compose(SaveHTML)_INPUTS.html'; StageFile = 'test5_partialSuccess/compose_inputs/inputs.html' },
    @{ RootPattern = 'test5_partialSuccess_Compose(SaveHTML)_OUTPUTS.html'; StageFile = 'test5_partialSuccess/compose_outputs/outputs.html' },
    @{ RootPattern = 'test5_partialSuccess_rawHTMLParameters.html'; StageFile = 'test5_partialSuccess/raw_parameters/raw_parameters.html' },
    @{ RootPattern = 'test4_PartialSuccess_Compose(SaveHTML)_INPUTS.html'; StageFile = 'test4_partialSuccess/compose_inputs/inputs.html' },
    @{ RootPattern = 'test4_PartialSuccess_Compose(SaveHTML)_OUTPUTS.html'; StageFile = 'test4_partialSuccess/compose_outputs/outputs.html' },
    @{ RootPattern = 'test4_PartialSuccess_SaveHTML_rawHTMLParameters.html'; StageFile = 'test4_partialSuccess/raw_parameters/raw_parameters.html' },
    @{ RootPattern = 'reportedFailure_SaveHTML_INPUTS.html'; StageFile = 'reportedFailure/compose_inputs/inputs.html' },
    @{ RootPattern = 'reportedFailure_SaveHTML_OUTPUTS.html'; StageFile = 'reportedFailure/compose_outputs/outputs.html' },
    @{ RootPattern = 'lastSuccessPriorToChange_Compose(SaveHTML)_INPUTS.html'; StageFile = 'baseline_lastSuccess/compose_inputs/inputs.html' },
    @{ RootPattern = 'lastSuccessPriorToChange_Compose(SaveHTML)_OUTPUTS.html'; StageFile = 'baseline_lastSuccess/compose_outputs/outputs.html' }
)

function Get-HashOrNull($path) {
  if (Test-Path $path) { (Get-FileHash -Algorithm SHA256 -Path $path).Hash } else { $null }
}

$plan = foreach ($m in $mapping) {
  $rootFile = Join-Path $root $m.RootPattern
  $stageFile = Join-Path $stageRoot $m.StageFile
  $rootHash = Get-HashOrNull $rootFile
  $stageHash = Get-HashOrNull $stageFile
  $hashEqual = $false
  if ($rootHash -and $stageHash) { $hashEqual = $rootHash -eq $stageHash }
  [PSCustomObject]@{
    RootFile = $rootFile
    StageFile = $stageFile
    RootExists = [bool]$rootHash
    StageExists = [bool]$stageHash
    HashEqual = $hashEqual
    SafeToDelete = ($hashEqual -and $rootHash -and $stageHash)
  }
}

$plan | Format-Table -AutoSize

if ($ExecuteCleanup) {
  $toDelete = $plan | Where-Object { $_.SafeToDelete }
  if ($toDelete.Count -eq 0) {
    Write-Host "No files eligible for deletion." -ForegroundColor Yellow
    exit 0
  }
  foreach ($f in $toDelete) {
    try {
      Remove-Item -Path $f.RootFile -Force
      Write-Host "Deleted: $($f.RootFile)" -ForegroundColor Green
    } catch {
      Write-Warning "Failed to delete: $($f.RootFile) -> $($_.Exception.Message)"
    }
  }
  Write-Host "Cleanup completed." -ForegroundColor Cyan
}
