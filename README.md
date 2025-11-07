# HBPC Admission Flow Repository

## Overview
This repository houses governance, forensic, and maintenance artifacts for the **HBPC New Admission Email With Saved Form** Power Automate flow. The flow generates a structured HTML admission summary populated from SharePoint list item data. A recent reconstruction (v0.1.0 baseline) restored previously truncated middle sections and standardized dynamic expression patterns for reliability and maintainability.

## Quickstart (60 Seconds)
1. Clone: `git clone <repo>` & checkout `main`.
2. Review architecture: see `docs/ARCHITECTURE.md` (Mermaid diagram of flow steps).
3. Run CI audit locally (optional): inspect `scripts/changelog-finalize.ps1` & upcoming audit script.
4. Make change in a branch (`feat/...` or `fix/...`), modify template HTML or JSON.
5. Validate with two flow runs (populated + sparse).
6. Update `CHANGELOG.md` Unreleased section; open PR using template.
7. After merge, export flow, place zip in `tests/flowSuccess/`, tag release.

## Current Architecture & Layout
```
root/
	README.md              <-- Project overview (this file)
	CHANGELOG.md           <-- Versioned change history
	.gitignore             <-- Git tracking rules (zip exports now included)
	.github/               <-- Issue & PR templates
	docs/                  <-- Detailed reports, schema & commit narratives
	scripts/               <-- Utility scripts (e.g., inputs_pretty regeneration)
	src/                   <-- (Reserved for future automation or tooling code)
	tests/                 <-- Reference artifacts (success/failure & altered states)
		altered/             <-- Repaired outputs & authoritative JSON
		flowFailure/         <-- Failing historical artifacts & export package
		flowSuccess/         <-- Successful historical artifacts & export package
```

## Key Artifacts (Authoritative & Historical)
| File | Location | Purpose |
|------|----------|---------|
| `altered_RawCodeView.json` | `tests/altered/` | Repaired Compose action JSON (authoritative mid-body pattern). |
| `altered_rawHTMLParameters.html` | `tests/altered/` | Editable HTML+expression template used during refactor. |
| `flowFailure_RawCodeView.json` | `tests/flowFailure/` | Truncated failing version for forensic comparison. |
| `flowSuccess_SaveHTML_INPUTS.html` | `tests/flowSuccess/` | Historical successful full HTML (blueprint for restore). |
| `exportedFailure_*.zip` | `tests/flowFailure/` | Full environment flow export at failing state. |
| `exportedSuccess_*.zip` | `tests/flowSuccess/` | Full environment flow export at successful state. |
| `FLOW_RECONSTRUCTION_REPORT.md` | `docs/` | Verbose technical remediation and analysis. |
| `FLOW_RECONSTRUCTION_REPORT_QUICK.md` | `docs/` | Concise stakeholder summary. |
| `FIELD_SCHEMA.md` | `docs/` | Data dictionary / PHI classification scaffold. |
| `VERBOSE_COMMIT_MESSAGE.txt` | `docs/` | First commit narrative (baseline). |
| `QUICK_COMMIT_MESSAGE.txt` | `docs/` | Abbreviated commit message. |
| `hbpc_admission_flow_issue.md` | `.github/ISSUE_TEMPLATE/` | Structured issue reporting template. |
| `PULL_REQUEST_TEMPLATE.md` | `.github/` | Standardized PR review checklist. |
| `regenerate_inputs_pretty.ps1` | `scripts/` | Regenerates readable mirror of escaped HTML string. |

## Expression & Fallback Strategy
Standard pattern for restored dynamic fields:
```
@{if(empty(outputs('Get_item')?['body/<FieldInternalName>/Value']), 'Not provided', outputs('Get_item')?['body/<FieldInternalName>/Value'])}
```
Principles:
1. Uniform emptiness handling using `if(empty(...),'Not provided',...)`.
2. Direct `/Value` dereferencing for choice/multi-select fields; omit `/Value` for pure text fields (verify before changes).
3. Readability support via non-executed `inputs_pretty` array (do not edit as source of truth).

## Regenerating `inputs_pretty`
1. Capture the current raw Compose `inputs` string (from Power Automate designer).
2. Save to a temporary file (e.g., `inputs_raw.txt`).
3. Run:
	 ```pwsh
	 ./scripts/regenerate_inputs_pretty.ps1 -InputFile inputs_raw.txt -OutputFile updated_inputs_pretty.json
	 ```
4. Replace the array contents inside `altered_RawCodeView.json` while keeping the primary `inputs` string intact.

## Workflow: Issue → Remediation → Validation → PR → Versioning
1. Open an issue with affected fields & sections using the template.
2. Branch from `main`; make minimal focused edits (prefer modifying template HTML file before raw JSON).
3. Validate with two runs: fully populated item + sparse/null fields item.
4. Submit PR referencing issue; include rollback export `.zip` name and diff summary.
5. Upon approval: merge, export fresh `.zip`, update `CHANGELOG.md`, tag release if major.
6. Schedule monthly diff against last known successful export.

## Data & Compliance Practices
| Control | Implementation |
|---------|----------------|
| PHI Protection | Mask sensitive examples; keep exports in private repo context. |
| Fallback Consistency | All dynamic fields should resolve to real value or `Not provided`. |
| Traceability | Zip exports now tracked for direct rollback. |
| Audit Trail | Reconstruction reports + CHANGELOG entries provide historical narrative. |

## Governance Roadmap (Near-Term)
- Add automated expression integrity checker (PowerShell) scanning for: missing fallback, unbalanced `@{}` tokens, orphaned `<div>` tags.
- Normalize top (Patient/Social/Medical) sections to standard fallback pattern.
- Populate `FIELD_SCHEMA.md` with authoritative types & PHI flags after schema verification.
- Introduce release tagging (`v0.1.0`, `v0.2.0`, etc.).

## Contributing Guidelines (Abbreviated)
| Step | Requirement |
|------|-------------|
| Prepare | Confirm field schema; avoid broad formatting edits. |
| Edit | Modify template or Compose JSON with minimal diff. |
| Validate | Run success + sparse test items; capture outputs. |
| Document | Update CHANGELOG + attach export zip. |
| Review | Pass PR checklist including rollback plan. |

## Troubleshooting Quick Reference
Symptom | Likely Cause | Action
--------|--------------|-------
Truncated mid-body HTML | Accidental overwrite | Compare against `flowSuccess_SaveHTML_INPUTS.html` and reapply section blocks.
Invalid expression error on save | Malformed string quoting or mismatched parentheses | Isolate changed expression, test standalone in temporary Compose.
Choice field displays JSON | Missing `/Value` dereference | Append `/Value` in path after field internal name.
Blank field where data exists | Incorrect field internal name or path | Cross-check with sample run outputs JSON.

## Security & Confidentiality
Artifacts reference internal VA workflows and may include PHI in raw exports or run histories. Keep repository access restricted. Do **not** publish externally. Redact patient identifiers in any shared screenshots.

## Status
Baseline reconstruction completed; governance and automation improvements pending. See `CHANGELOG.md` for version history.

---
_Last updated: 2025-11-07_
