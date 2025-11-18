# Root Artifact Migration Plan

## Overview
This document enumerates every artifact currently residing in the repository root and recommends its target location inside the structured hierarchy (`src/flows/HBPCNewAdmissionEmailWithSavedForm/stages/...`, `docs/...`, `scripts/...`, etc.). The goal is to achieve:
- Stage isolation (baseline_lastSuccess, reportedFailure, test4_partialSuccess, test5_partialSuccess).
- Consistent, concise internal filenames (context carried by folder path rather than verbose filename prefixes).
- Clear separation of flow run artifacts vs diagnostics, documentation, and automation tooling.
- Minimal ambiguity: temporary or legacy artifacts are flagged for archive or deletion after verification.

## Naming Conventions (Proposed)
Inside each stage directory:  
```
compose_inputs/      -> inputs.html
compose_outputs/     -> outputs.html
raw_parameters/      -> raw_parameters.html (or .json if converted later)
peek_raw_code/       -> peek_raw_code.json (flow segment); flow_raw.json for full export
exports/             -> flow_export.zip (ZIP export of flow)
reports/             -> {quick|verbose}_report.md
commits/             -> {quick|verbose}_commit.txt or .md
issues/              -> issue_filled.txt (or issue_<id>.txt when ticketing integrated)
metadata/            -> runInfo.json (timestamps, status, counts), notes.md (optional)
```
Diagnostics & cross-stage analyses live under `docs/diagnostics/`.
Structural & governance docs live under `docs/governance/` or `docs/schemas/` as appropriate.

## Artifact Mapping Table
| Current Root Artifact | Stage Classification | Recommended Target Path | Rename? | Rationale |
|-----------------------|----------------------|-------------------------|---------|-----------|
| `HBPC_AdmitsDischarges.code-workspace` | Global config | `.vscode/HBPC_AdmitsDischarges.code-workspace` (create `.vscode/`) | No | Keep IDE workspace config isolated; optional move. Root ok if preferred. |
| `README.md` | Global doc | `README.md` (stay) | No | Conventional root README. |
| `CHANGELOG.md` | Global doc | `CHANGELOG.md` (stay or `docs/governance/CHANGELOG.md`) | No | Root changelog is standard; move only if preferring docs consolidation. |
| `.github/` | Global automation | `.github/` (stay) | No | Standard location for workflows & templates. |
| `STRUCTURE_MAP.md` | Global structural doc | `docs/governance/STRUCTURE_MAP.md` | No | Governance / architectural reference. |
| `MISPOPULATING_BLOCKS_ANALYSIS_test5_vs_baseline.md` | Cross-stage diagnostics | `docs/diagnostics/mispopulating_blocks_test5_vs_baseline.md` | Yes (lowercase) | Analytical report; belongs in diagnostics. |
| `test5_partialSuccess_workspaceUpdates&fileDocumentation_verboseReport.md` | Stage report (test5) | `src/flows/HBPCNewAdmissionEmailWithSavedForm/stages/test5_partialSuccess/reports/verbose_report.md` | Yes | Normalize naming; stage context from path. |
| `test5_partialSuccess_workspaceUpdates&fileDocumentation_verboseCommitMessage.txt` | Stage commit (test5) | `src/flows/HBPCNewAdmissionEmailWithSavedForm/stages/test5_partialSuccess/commits/verbose_commit.txt` | Yes | Commit narrative; shorten. |
| `test5_partialSuccess_Compose(SaveHTML)_INPUTS.html` | test5 compose inputs | `.../test5_partialSuccess/compose_inputs/inputs.html` | Yes | Standard inputs filename. |
| `test5_partialSuccess_Compose(SaveHTML)_OUTPUTS.html` | test5 compose outputs | `.../test5_partialSuccess/compose_outputs/outputs.html` | Yes | Standard outputs filename. |
| `test5_partialSuccess_Compose(SaveHTML)_peekRawCode.json` | test5 raw code peek | `.../test5_partialSuccess/peek_raw_code/peek_raw_code.json` | Yes | Standard. |
| `test5_partialSuccess_rawHTMLParameters.html` | test5 parameters | `.../test5_partialSuccess/raw_parameters/raw_parameters.html` | Yes | Standard. |
| `test5_partialSuccess_exportedFlowSourceCode.zip` | test5 full flow export | `.../test5_partialSuccess/exports/flow_export.zip` (exports folder needs creation) | Yes | Keep ZIP isolated; add `exports/` subfolder. |
| `lastSuccessPriorToChange_Compose(SaveHTML)_INPUTS.html` | baseline inputs | `.../baseline_lastSuccess/compose_inputs/inputs.html` | Yes | Baseline stage inputs. |
| `lastSuccessPriorToChange_Compose(SaveHTML)_OUTPUTS.html` | baseline outputs | `.../baseline_lastSuccess/compose_outputs/outputs.html` | Yes | Baseline stage outputs. |
| `lastSuccessPriorToChange_exportedFlow_RawJSON.json` | baseline flow raw JSON | `.../baseline_lastSuccess/peek_raw_code/flow_raw.json` | Yes | Differentiate raw full export from peek. |
| `reportedFailure_SaveHTML_INPUTS.html` | failure inputs | `.../reportedFailure/compose_inputs/inputs.html` | Yes | Normalize. |
| `reportedFailure_SaveHTML_OUTPUTS.html` | failure outputs | `.../reportedFailure/compose_outputs/outputs.html` | Yes | Normalize. |
| `reportedFailure_Compose(SaveHTML)_peekRawCode.json` | failure peek | `.../reportedFailure/peek_raw_code/peek_raw_code.json` | Yes | Normalize. |
| `reportedFailure_exportedFlowSourceCode.zip` | failure flow export | `.../reportedFailure/exports/flow_export.zip` | Yes | Add exports subfolder. |
| `test4_PartialSuccess_Compose(SaveHTML)_INPUTS.html` | test4 inputs | `.../test4_partialSuccess/compose_inputs/inputs.html` | Yes | Normalize. |
| `test4_PartialSuccess_Compose(SaveHTML)_OUTPUTS.html` | test4 outputs | `.../test4_partialSuccess/compose_outputs/outputs.html` | Yes | Normalize. |
| `test4_PartialSuccess_Compose(SaveHTML)_peekRawCode.json` | test4 peek | `.../test4_partialSuccess/peek_raw_code/peek_raw_code.json` | Yes | Normalize. |
| `test4_PartialSuccess_SaveHTML_rawHTMLParameters.html` | test4 parameters | `.../test4_partialSuccess/raw_parameters/raw_parameters.html` | Yes | Normalize. |
| `test4_PartialSuccess_exportedFlowSourceCode.zip` | test4 flow export | `.../test4_partialSuccess/exports/flow_export.zip` | Yes | Add exports subfolder. |
| `test4_partialSuccess_Troubleshooting&Solution_quickReport.md` | test4 quick report | `.../test4_partialSuccess/reports/quick_report.md` | Yes | Standard quick report name. |
| `test4_partialSuccess_Troubleshooting&Solution_verboseReport.md` | test4 verbose report | `.../test4_partialSuccess/reports/verbose_report.md` | Yes | Standard verbose report name. |
| `test4_partialSuccess_Troubleshooting&Solution_quickCommitMessage.txt` | test4 quick commit | `.../test4_partialSuccess/commits/quick_commit.txt` | Yes | Normalize. |
| `test4_partialSuccess_Troubleshooting&Solution_verboseCommitMessage.txt` | test4 verbose commit | `.../test4_partialSuccess/commits/verbose_commit.txt` | Yes | Normalize. |
| `test4_partialSuccess_Troubleshooting&Solution_filledIssue.txt` | test4 issue artifact | `.../test4_partialSuccess/issues/issue_filled.txt` | Yes | Standard issue file name. |
| `__temp_test5_stageHeaderSummary.md` | Temporary staging doc | `docs/diagnostics/_archive/__temp_test5_stageHeaderSummary.md` or delete | Maybe | Archive until all data merged; safe to delete afterwards. |
| `archived_2025.11.06_‏‎23.59.59/` | Historical snapshot | `archives/2025-11-06_23-59-59/` (new root-level `archives/`) | Rename dir | Preserve immutable snapshot; move out of active root to reduce clutter. |
| `scripts/` (contains `regenerate_inputs_pretty.ps1`) | Automation | `scripts/maintenance/regenerate_inputs_pretty.ps1` | Yes (create maintenance/) | Classify maintenance utilities; consider adding README. |
| `src/` | Implementation | `src/` (stay) | No | Houses structured flow hierarchy already. |
| `docs/` | Documentation | `docs/` (stay) | No | Centralized docs root. |
| `outputs/` | Generated outputs | `outputs/html/` or stage-specific relocation (optional) | Maybe | If outputs mirror stage artifacts, consolidate into stage folders; otherwise keep for aggregated exports. |

## Additional Structural Adjustments Needed
1. Create an `exports/` subfolder in each existing stage to house flow export ZIPs.  
2. Create `.vscode/` directory if adopting workspace config move.  
3. Create `archives/` directory for historical snapshots.  
4. Create `docs/diagnostics/` and `docs/governance/` subfolders if not already present (governance may already partially exist).  
5. Optionally add `docs/schemas/field_schema_reference.md` by relocating `referenceDoc_FIELD_SCHEMA.md` (not listed in current root scan; if still present elsewhere, migrate accordingly).  
6. Add `scripts/maintenance/` to classify recurring helper scripts.  

## Ambiguities / Verification Checklist
| Item | Question | Action Before Move |
|------|----------|--------------------|
| `outputs/` aggregated content | Are these duplicates of stage outputs or aggregated transforms? | Confirm; if duplicates, remove after relocation. |
| `__temp_test5_stageHeaderSummary.md` | Any unique data not in verbose commit/report? | Diff vs verbose commit; archive or delete. |
| `archived_2025.11.06_‏‎23.59.59/` | Should contents be partially merged into baseline? | Typically keep immutable; only extract if missing baseline artifacts. |
| Flow export ZIP naming | Need versioning? | Optionally append semantic version (e.g., `flow_export_v2025.11.07.zip`). |

## Execution Order (Recommended)
1. Create missing structural folders (`exports/`, `archives/`, `.vscode/`, diagnostics/governance subfolders, maintenance scripts subfolder).  
2. Move & rename baseline artifacts.  
3. Move failure artifacts.  
4. Move test4 artifacts.  
5. Move test5 artifacts.  
6. Relocate diagnostics & governance docs.  
7. Handle temporary & archive directories.  
8. Generate `runInfo.json` per stage with normalized metadata.  
9. Clean residual originals after validation (ensure git history preserved via moves).  

## Sample `runInfo.json` Schema
```json
{
  "stage": "test5_partialSuccess",
  "status": "partialSuccess",
  "runDate": "2025-11-07",
  "artifactSet": {
    "inputs": "inputs.html",
    "outputs": "outputs.html",
    "parameters": "raw_parameters.html",
    "peekRawCode": "peek_raw_code.json",
    "flowExport": "exports/flow_export.zip"
  },
  "metrics": {
    "fieldsPopulated": 42,
    "fieldsMissing": 2
  },
  "notes": ["Admission Date field mis-populating; see diagnostics report."],
  "sourceSnapshot": "commit <TBD SHA after move>"
}
```

## Next Steps
After approval of this plan, proceed with automated moves and filename normalization, then create per-stage `runInfo.json` and prune temporary artifacts.

---
Prepared: 2025-11-07  
Authoring Assistant: Migration planning module
\
\
## Migration Addendum (2025-11-07)

### Stage Completion Matrix
| Stage | Status | Inputs | Outputs | Raw Parameters | Peek Raw Code | Reports | Commits | Issue | Export ZIP | Placeholders Remaining |
|-------|--------|--------|---------|----------------|---------------|---------|---------|-------|------------|------------------------|
| baseline_lastSuccess | FULL_SUCCESS | ✓ | ✓ (abbrev) | ✗ (placeholder) | ✓ (truncated) | ✗ (placeholder) | ✗ (placeholder) | n/a | (none) | 3 |
| reportedFailure | FAILURE | ✓ | ✓ | ✗ | ✓ (partial) | ✗ | ✗ | ✗ | ✓ | 4 |
| test4_partialSuccess | PARTIAL_SUCCESS | ✓ | ✓ | ✓ | ✓ (partial) | ✓ (2) | ✓ (2) | ✓ | ✓ | 0 |
| test5_partialSuccess | PARTIAL_SUCCESS | ✓ (placeholder content) | ✓ (placeholder content) | ✓ (placeholder) | ✓ (partial) | ✓ (2) | ✓ (2) | ✓ | ✓ | 3 |

Legend: ✓ present; ✗ placeholder/absent; (2) indicates both quick & verbose present.

### Placeholder Inventory
| Stage | Placeholder Files |
|-------|-------------------|
| baseline_lastSuccess | raw_parameters.html, baseline_report.md, baseline_commit.txt |
| reportedFailure | raw_parameters.html, failure_report.md, failure_commit.txt, issue.md |
| test5_partialSuccess | inputs.html, outputs.html, raw_parameters.html |

### Export ZIP Normalization
- reportedFailure_exportedFlowSourceCode.zip -> `reportedFailure/exports/flow_export.zip`
- test4_PartialSuccess_exportedFlowSourceCode.zip -> `test4_partialSuccess/exports/flow_export.zip`
- test5_partialSuccess_exportedFlowSourceCode.zip -> `test5_partialSuccess/exports/flow_export.zip`
- Baseline: No ZIP discovered; placeholder README added.

### Safe-to-Delete (Post-Validation) Candidates
(Do NOT delete until verification checklist completed.)
- Root: `test4_PartialSuccess_exportedFlowSourceCode.zip`, `test5_partialSuccess_exportedFlowSourceCode.zip`, `reportedFailure_exportedFlowSourceCode.zip` (now relocated)
- Root prefixed input/output/parameter/peek files once diffs confirmed identical to staged copies.
- Temporary: `__temp_test5_stageHeaderSummary.md` (archive or delete)

### Verification Checklist Before Deletion
1. Binary equality (or text diff) between staged artifacts and root originals.
2. Confirm no unreferenced fields exist only in root versions.
3. Ensure runInfo.json for each stage lists export ZIP (or placeholder) correctly.
4. Git history captures moves (commit diff review).
5. Baseline missing ZIP acknowledged or provided.

### Pending Actions
- Replace placeholder HTML with full original content for baseline & reportedFailure & test5 where applicable.
- Add diagnostics file for mis-populating blocks under `docs/diagnostics/` if not yet created.
- Introduce automated validation script (PowerShell) to assert placeholder count == 0 for a "fully migrated" stage.

### Suggested Automation Snippet (PowerShell)
```powershell
$stages = Get-ChildItem "src/flows/HBPC_AdmitsDischarges/stages" -Directory
foreach ($stage in $stages) {
  $runInfoPath = Join-Path $stage.FullName 'metadata/runInfo.json'
  if (Test-Path $runInfoPath) {
    $json = Get-Content $runInfoPath -Raw | ConvertFrom-Json
    $placeholders = @()
    if ($json.placeholders) { $placeholders += $json.placeholders }
    if ($json.artifacts) {
      # Deep scan for placeholder flags
      $json.artifacts.psobject.Properties | ForEach-Object {
        $val = $_.Value
        if ($val -is [System.Collections.Hashtable] -and $val.placeholder) { $placeholders += $val.file }
      }
    }
    [PSCustomObject]@{Stage=$json.stage;PlaceholderCount=$placeholders.Count;Placeholders=$placeholders -join ', '} | Format-Table -AutoSize
  }
}
```

### Future Stage (test6_pending) Preparatory Notes
- Objective: Eliminate remaining 2 mis-populating blocks; elevate test5 placeholders to full content.
- Success criteria: Placeholder count == 0; misPopulatingBlocks == 0; export ZIP present.

#### test6_pending Scaffold Status
- Directory created with full substructure (compose_inputs, compose_outputs, raw_parameters, peek_raw_code, reports, commits, issues, metadata, exports).
- All artifacts currently placeholders; runInfo.json seeded with remediation expressions for HBPC Admission Date and DoesTheVeteranUse fields.
- Awaiting flow modification & execution before replacing placeholders.

---
Addendum Prepared: 2025-11-07  
Authoring Assistant: Migration planning module
