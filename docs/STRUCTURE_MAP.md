# Repository Structure Map

## High-Level Layout
```
/README.md                (Project overview)
/CHANGELOG.md             (Release & change history)
/.gitignore               (Ignore rules)
/LICENSE (optional)       (Add if required)
/src/                     (Source-controlled logical definitions & configuration)
  flows/
    HBPCNewAdmissionEmailWithSavedForm/
      common/             (Shared templates, expression patterns, lint notes)
      exports/            (Versioned solution export zips or metadata manifests)
      tests/              (Test scenario definitions, run matrices)
      stages/             (Chronological remediation iterations)
        baseline_lastSuccess/
        reportedFailure/
        test4_partialSuccess/
        test5_partialSuccess/
        test6_pending/    (Placeholder for next iteration artifacts)
  powerapps/              (Canvas app resources, form schemas, screen specs)
  sharepoint/             (List schemas, field dictionaries, provisioning scripts)
/docs/
  reports/                (Verbose & quick reports aggregating work)
    stages/               (Per-stage documentation snapshots)
  governance/             (Issue/PR templates, process docs, SOPs)
  schemas/                (Field schema tables, data dictionary expansions)
  diagnostics/            (Analysis artifacts: mis-populating blocks, diff notes)
/outputs/
  html/                   (Final generated admission HTML documents for test runs)
  exports/                (Archived solution exports for rollback)
/scripts/                 (Automation scripts)
  maintenance/            (Integrity checks, schema validation, regeneration tools)
```

## Stage Directory Conventions
Each stage directory under `src/flows/HBPCNewAdmissionEmailWithSavedForm/stages/<stageName>/` should contain:
```
compose_inputs/      (Raw HTML from Compose INPUTS snapshot)
compose_outputs/     (Rendered OUTPUTS if captured separately)
raw_parameters/      (Human-editable or refactored parameter HTML)
peek_raw_code/       (Peek raw JSON representation of Compose action)
reports/             (Stage-specific quick + verbose report markdown)
commits/             (Verbose + quick commit messages)
issues/              (Filled issue templates, if any)
metadata/            (Run timestamps, line metrics, diff summaries)
```

## Migration Guidance (Existing Artifacts)
- `lastSuccessPriorToChange_Compose(SaveHTML)_INPUTS.html` → `stages/baseline_lastSuccess/compose_inputs/`
- `lastSuccessPriorToChange_Compose(SaveHTML)_OUTPUTS.html` → `stages/baseline_lastSuccess/compose_outputs/`
- `reportedFailure_SaveHTML_INPUTS.html` / `_OUTPUTS.html` → `stages/reportedFailure/compose_inputs|compose_outputs/`
- `test4_PartialSuccess_Compose(SaveHTML)_INPUTS.html` / `_OUTPUTS.html` → `stages/test4_partialSuccess/compose_inputs|compose_outputs/`
- `test4_PartialSuccess_Compose(SaveHTML)_peekRawCode.json` → `stages/test4_partialSuccess/peek_raw_code/`
- `test4_PartialSuccess_SaveHTML_rawHTMLParameters.html` → `stages/test4_partialSuccess/raw_parameters/`
- `test5_partialSuccess_Compose(SaveHTML)_INPUTS.html` → `stages/test5_partialSuccess/compose_inputs/`
- `test5_partialSuccess_Compose(SaveHTML)_peekRawCode.json` → `stages/test5_partialSuccess/peek_raw_code/`
- `test5_partialSuccess_rawHTMLParameters.html` → `stages/test5_partialSuccess/raw_parameters/`
- Reports & commit messages (test4/test5) → respective `reports/` and `commits/` subfolders.
- Mis-populating analysis → `docs/diagnostics/` (or duplicate under `test5_partialSuccess/metadata/`).

## Future Test6 Artifact Placeholders
Under `stages/test6_pending/` create same subfolder set before executing Test6:
```
compose_inputs/
compose_outputs/
raw_parameters/
peek_raw_code/
reports/
commits/
issues/
metadata/
```
Populate after run: capture INPUTS, OUTPUTS, peek JSON, raw parameters changes, new commit/report, and a validation metadata file.

## Shared & Common Assets
- `src/flows/.../common/` → Expression pattern templates, `inputs_pretty` regeneration notes, fallback pattern library.
- `docs/schemas/` → Expanded `FIELD_SCHEMA.md` + `referenceDoc_FIELD_SCHEMA.md`.
- `scripts/maintenance/` → Planned integrity scripts (expression consistency, section presence, fallback enforcement).

## Governance Assets
- Move `.github/ISSUE_TEMPLATE/*` and `.github/PULL_REQUEST_TEMPLATE.md` references into `docs/governance/` (retain `.github` root for GitHub to use; duplicate text if needed for offline audit).
- Add CONTRIBUTING.md (optional) summarizing workflow, staging, test execution order.

## Suggested .gitignore Entries
```
# Power Automate / Export Artifacts
*.zip
# Temp & working docs
__temp_*.
MISPOPULATING_*_analysis*.md
# Generated HTML outputs (optional if large)
/outputs/html/*.html
# Local editor & OS
*.code-workspace
Thumbs.db
.DS_Store
```

## Recommended Next Steps
1. Manually move existing files into their mapped stage subfolders.
2. Add missing subfolders (compose_inputs, etc.) inside each stage as needed.
3. Create initial metadata file per stage (e.g., `metadata/runInfo.json`).
4. Expand field schema and add integrity script under `scripts/maintenance/`.
5. Commit staged reorganization with a dedicated refactor commit.

---
Generated: 2025-11-07
