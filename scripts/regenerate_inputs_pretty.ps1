<#
    Copyright (c) 2025 Coder, Kyle J. and Zakarian, Ara A.
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

    .SYNOPSIS
        Regenerates a JSON array of HTML lines (inputs_pretty) from a raw Compose 'inputs' string export.
    .DESCRIPTION
        Reads a file containing the exact HTML string used in the Power Automate Compose action.
        Splits on newline, trims trailing whitespace, escapes embedded quotes, and outputs a JSON array.
        By default filters out completely blank lines except structural separators; use -IncludeAll to retain all.
    .NOTES
        Do NOT modify the flow by editing this output directly without updating the original Compose 'inputs'.
        After generation, paste array into `altered_RawCodeView.json` under `inputs_pretty`.
    .EXAMPLE
        ./regenerate_inputs_pretty.ps1 -InputFile inputs_raw.txt -OutputFile updated_inputs_pretty.json
#>
param(
        [Parameter(Mandatory=$true)][string]$InputFile,
        [Parameter(Mandatory=$true)][string]$OutputFile,
        [switch]$IncludeAll
)

if(!(Test-Path $InputFile)) { throw "Input file not found: $InputFile" }

$raw = Get-Content -Raw -Path $InputFile
# Normalize Windows line endings
$raw = $raw -replace "\r\n", "\n"

$lines = $raw -split "\n"

$result = @()
foreach($line in $lines){
    $trimmed = $line.TrimEnd()
    if(-not $IncludeAll){
        # Keep non-empty or lines that contain section markers/comments
        if($trimmed -eq "") { continue }
    }
    # Escape double quotes for JSON safety
    $escaped = $trimmed -replace '"','\\"'
    $result += "\"$escaped\""
}

$json = "[" + ($result -join ",\n") + "]"
Set-Content -Path $OutputFile -Value $json -Encoding UTF8
Write-Host "Generated inputs_pretty array with $($result.Count) lines -> $OutputFile"
