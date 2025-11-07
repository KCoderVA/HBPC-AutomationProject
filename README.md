# HBPC Admission Flow Artifacts

## Purpose
This workspace contains documentation and supporting artifacts for the **HBPC New Admission Email With Saved Form** Power Automate flow. The flow composes a rich HTML admission summary embedding SharePoint list item data. Recent remediation restored truncated sections and standardized dynamic expressions.

## Key Files
| File | Purpose |
|------|---------|
| `altered_RawCodeView.json` | Current repaired Compose action JSON (authoritative). |
| `flowFailure_RawCodeView.json` | Historical truncated failing version for forensic comparison. |
| `FLOW_RECONSTRUCTION_REPORT.md` | Full verbose reconstruction & analysis. |
| `FLOW_RECONSTRUCTION_REPORT_QUICK.md` | Stakeholder-facing concise summary. |
| `VERBOSE_COMMIT_MESSAGE.txt` | Detailed commit message (archival). |
| `QUICK_COMMIT_MESSAGE.txt` | Short commit message summary. |
| `.github/ISSUE_TEMPLATE/hbpc_admission_flow_issue.md` | Issue reporting template (includes VA employee demographics). |
| `.github/PULL_REQUEST_TEMPLATE.md` | Pull request review & validation checklist. |
| `altered_SaveHTML_Paramters.html` | Human-editable HTML template for mid-section expressions. |
| `scripts/regenerate_inputs_pretty.ps1` | Automation script to regenerate readable `inputs_pretty` array. |
| `FIELD_SCHEMA.md` | Field inventory & data classification placeholders. |
| `CHANGELOG.md` | Chronological change log of major updates. |

## Compose Action Strategy
- All restored fields use pattern: `if(empty(outputs('Get_item')?['body/<Field>/Value']), 'Not provided', outputs('Get_item')?['body/<Field>/Value'])`.
- Fallback text unified as `Not provided`.
- Choice / complex SharePoint columns dereferenced via `/Value`; plain text fields should omit `/Value` (verify before modifications).
- Readability mirror held in `inputs_pretty` (non-executed; for review only). Always modify the primary `inputs` string in the Compose action, then regenerate mirror.

## Regenerating `inputs_pretty`
1. Export current flow or copy raw Compose `inputs` string to `inputs_raw.txt`.
2. Run PowerShell script: `./scripts/regenerate_inputs_pretty.ps1 -InputFile inputs_raw.txt -OutputFile updated_inputs_pretty.json`.
3. Replace array content in `altered_RawCodeView.json` (do **not** remove existing `inputs`).

## Governance & Process
1. **Issue**: Use issue template; capture demographic data & affected fields.
2. **Remediation**: Work in a branch / environment, edit HTML or expressions.
3. **Validation**: Run test item with full data + sparse data; confirm all sections render.
4. **PR**: Use PR template; include rollback plan referencing previous export zip.
5. **Versioning**: Update `CHANGELOG.md`; archive new solution export.
6. **Monitoring**: Monthly diff review and automated expression integrity scan (planned).

## Field Classification (See `FIELD_SCHEMA.md`)
Maintain internal names, display labels, data types, PHI classification, and fallback policy.

## Risk Controls Implemented
- Section boundary comments to prevent silent mid-body deletion.
- Standardized null handling to prevent parser errors.
- Documentation artifacts for rapid onboarding and audit trails.

## Pending Enhancements
- Automate expression integrity check.
- Normalize top-section expressions to unified pattern.
- Integrate source control (Git) and CI validation pipeline.

## Contributing
1. Fork/branch and make minimal focused edits.
2. Avoid altering unrelated styling or spacing within large HTML strings.
3. Ensure no PHI leaves secure environment in screenshots.
4. Submit PR with all checklist items satisfied.

## License / Confidentiality
Internal VA project artifacts; treat all patient-related data as protected PHI/PII. Do not publish externally.

---
_Last updated: 2025-11-06_
