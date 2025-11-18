# HBPC Admission Flow Repository

<!-- BADGES:START -->
<div>
<strong>Badges</strong>:<br/>
<code>License: Apache-2.0</code> • <code>Governance: Active</code> • <code>Schema Fields: 11</code> • <code>Reconstruction: Stable</code>
</div>
<!-- BADGES:END -->
<p><img alt="Schema Fields" src="assets/badges/schema-field-count.svg" /></p>

<!-- BUILDINFO:START --><div><em>Build Info</em>: Commit <code>5f68396</code> • UTC <code>2025-11-07</code> • Last Tag <code>v0.4.0</code> • Commits Since Tag <code>0</code> • Files Since Tag <code>0</code> • Schema Fields Snapshot <code>11</code></div><!-- BUILDINFO:END -->

## Overview
This repository houses governance, forensic, and maintenance artifacts for the **HBPC New Admission Email With Saved Form** Power Automate flow. The flow generates a structured HTML admission summary populated from SharePoint list item data. Reconstruction (v0.1.0 baseline) restored truncated middle sections; subsequent governance (v0.1.1) introduced tracked exports, architecture documentation, and config scaffolding; current end-of-day adds formal governance + CI + semantic versioning support.

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
<!-- ARTIFACT-TABLE:START -->
| File | Location | Purpose |
|------|----------|---------|
| `altered_RawCodeView.json` | `tests/altered/` | Repaired Compose action JSON (authoritative mid-body pattern). |
| `altered_rawHTMLParameters.html` | `tests/altered/` | Editable HTML+expression template used during refactor. |
| `flowFailure_RawCodeView.json` | `tests/flowFailure/` | Truncated failing version for forensic comparison. |
| `flowSuccess_SaveHTML_INPUTS.html` | `tests/flowSuccess/` | Historical successful full HTML (blueprint for restore). |
| `exportedFailure_*.zip` | `tests/flowFailure/` | Full environment flow export at failing state. |
| `exportedSuccess_*.zip` | `tests/flowSuccess/` | Full environment flow export at successful state. |
| `FLOW_RECONSTRUCTION_REPORT.md` | `docs/` | Verbose technical remediation & analysis. |
| `FLOW_RECONSTRUCTION_REPORT_QUICK.md` | `docs/` | Concise stakeholder summary. |
| `FIELD_SCHEMA.md` | `docs/` | Data dictionary / PHI classification scaffold (generated/enriched). |
| `VERBOSE_COMMIT_MESSAGE.txt` | `docs/` | Initial verbose commit narrative (baseline). |
| `QUICK_COMMIT_MESSAGE.txt` | `docs/` | Abbreviated baseline commit message. |
| `hbpc_admission_flow_issue.md` | `.github/ISSUE_TEMPLATE/` | Structured issue reporting template. |
| `PULL_REQUEST_TEMPLATE.md` | `.github/` | Standardized PR review checklist. |
| `regenerate_inputs_pretty.ps1` | `scripts/` | Regenerates readable mirror of escaped HTML string. |
| `changelog-finalize.ps1` | `scripts/` | Promotes Unreleased section in CHANGELOG to version + optional tag. |
| `fieldSchema.json` | `config/` | Machine-readable authoritative field schema scaffold (drives future audits). |
| `GOVERNANCE.md` | `governance/` | Roles, versioning rules, release flow, incident response. |
| `CONTRIBUTING.md` | `governance/` | Branching, commit conventions, PR requirements, PHI rules. |
| `SECURITY.md` | `governance/` | Security & PHI reporting guidance. |
| `RELEASE.md` | `governance/` | Release procedure & tagging policy. |
| `LABELS.md` | `governance/` | Issue label taxonomy. |
| `copilot-instructions.md` | `.github/` | Full AI collaboration contract & guardrails (authoritative). |
| `copilot-quickref.md` | `dev/` | Condensed Copilot checklist. |
| `HBPC_Automation.code-workspace` | `dev/` | VS Code workspace settings. |
| `CODEOWNERS` | root | Automatic review assignment. |
| `LICENSE.txt` | root | Apache 2.0 license (joint copyright: Kyle J. Coder & Ara A. Zakarian). |
| `ARCHITECTURE.md` | `docs/` | Flow component diagram & extension points. |
<!-- ARTIFACT-TABLE:END -->

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

## Active Governance & Roadmap
Implemented Today:
- CI workflow (`.github/workflows/ci.yml`) validating field schema, CHANGELOG Unreleased presence, README quickstart, external link health.
- Central field schema config (`config/fieldSchema.json`).
- CHANGELOG automation script.
- Formal governance & contributing documents.
- Architecture diagram.

Up Next (Planned):
1. Expression audit script (fallback + `/Value` correctness + balance checks).
2. Normalization of top Patient/Social/Medical sections to unified `if(empty())` pattern.
3. Authoritative population of remaining field schema entries (automated extraction from run JSON).
4. Release script bundling export → audit → changelog finalize → tag.
5. Security protocol document & anonymization script for HTML output.
6. Test harness (Pester or custom) verifying section counts & fallback coverage.

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

## Security, Licensing & Confidentiality
Licensed under Apache 2.0 (see `LICENSE.txt`). Joint Copyright (c) 2025 Kyle J. Coder & Ara A. Zakarian.

Artifacts reference HBPC clinical workflows. All committed examples must be de-identified. Do **not** include PHI (names, full addresses, unmasked SSN, MRNs) in issues, PRs, or screenshots. Use anonymization tooling (planned) for any real output prior to sharing externally.

## Status
EOD 2025-11-07: Baseline reconstruction (v0.1.0) + governance/structure enhancements (v0.1.1) + formal contributor, versioning, CI, architecture & schema scaffolds now in place. Pending automation (audit + normalization) slated for v0.1.2. Badge schema field count will be updated via future automation script.

---
_Last updated: 2025-11-07 (EOD)_

