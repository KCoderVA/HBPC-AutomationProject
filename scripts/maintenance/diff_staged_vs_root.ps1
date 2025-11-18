<#
SPDX-License-Identifier: Apache-2.0
.SYNOPSIS
Compares root artifacts to staged normalized copies to ensure content parity before root cleanup.
.DESCRIPTION
For each known pattern, attempts to locate the root file and its staged counterpart, computing SHA256 hashes.
Outputs a table summarizing equality. Nonexistent pairs are flagged. Intended to run prior to any deletion.
#>

$ErrorActionPreference = 'Stop'
$root = (Get-Location).Path
$stageRoot = Join-Path $root 'src\flows\HBPC_AdmitsDischarges\stages'

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

$results = foreach ($m in $mapping) {
  $rootFile = Join-Path $root $m.RootPattern
  $stageFile = Join-Path $stageRoot $m.StageFile
  $rootHash = Get-HashOrNull $rootFile
  $stageHash = Get-HashOrNull $stageFile
  [PSCustomObject]@{
    RootFile = $m.RootPattern
    StageFile = $m.StageFile
    RootExists = [bool]$rootHash
    StageExists = [bool]$stageHash
    HashEqual = if($rootHash -and $stageHash){ $rootHash -eq $stageHash } else { $false }
  }
}

$results | Format-Table -AutoSize

# Exit with 0 if all existing pairs match; 1 otherwise
if (($results | Where-Object { $_.RootExists -and $_.StageExists -and -not $_.HashEqual }).Count -eq 0) { exit 0 } else { exit 1 }
