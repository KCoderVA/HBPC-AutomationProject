# Contributing to HBPC Admission Flow Repository

Welcome! This repo manages governance and forensic artifacts for the **HBPC New Admission Email With Saved Form** Power Automate flow. Because clinical and PHI considerations apply, please follow the rules below.

## 1. Branching Strategy
| Purpose | Prefix | Example |
|---------|--------|---------|
| Feature / Enhancement | feat/ | feat/normalize-top-section-fallbacks |
| Bug Fix | fix/ | fix/adldressing-expression-parentheses |
| Documentation | docs/ | docs/add-security-guidelines |
| Chore / Infra | chore/ | chore/add-ci-audit-workflow |
| Experiment (not for merge) | exp/ | exp/html-minify-test |

Always branch from `main`. Keep branches focused (single logical change).

## 2. Commit Message Convention (Conventional Commits)
Format: `<type>(scope): summary`
Types: feat, fix, docs, chore, refactor, test, ci.
Example: `feat(expressions): unify fallback in patient section`

## 3. Pull Requests
Use the PR template. Requirements:
- Link related issue (or create one if none).
- Include before/after artifact references (HTML output or diff summary).
- Provide rollback plan (prior export .zip tag or commit SHA).
- Confirm audit script passes (`scripts/audit-compose.ps1`).

## 4. Semantic Versioning
Pattern: MAJOR.MINOR.PATCH
- MAJOR: Structural redesign or breaking HTML section reorganization.
- MINOR: New sections, new schema fields, added governance automation.
- PATCH: Documentation, small script fixes, non-breaking expression normalization.

Tags: `v0.1.1`, `v0.1.2`, etc. Use release script (future) or manual: `git tag -a v0.1.2 -m "v0.1.2: FIELD_SCHEMA authoritative update"`.

## 5. Flow Export Handling
After merge:
1. Export current flow (solution package or direct export) – store zip in `tests/flowSuccess/`.
2. Name pattern: `exportedSuccess_HBPCNewAdmissionEmailWithSavedForm_<UTCYYYYMMDDHHmmss>.zip`.
3. Update CHANGELOG Unreleased section → version.
4. Tag release.

## 6. PHI/PII & Security
- Never commit real patient identifiers beyond controlled examples.
- Mask SSN, addresses, phone numbers in documentation (use placeholders).
- Redact run history screenshots; verify no patient-specific HTML in sample attachments.
- Use anonymization script (future) before sharing outputs outside secure context.

## 7. Expression Standards
All dynamic value lines should follow pattern:
```
@{if(empty(outputs('Get_item')?['body/<FieldInternalName>/Value']), 'Not provided', outputs('Get_item')?['body/<FieldInternalName>/Value'])}
```
Exceptions only documented via PR (e.g., using `Unknown`).

## 8. Field Schema Updates
Update `config/fieldSchema.json` first. Run generator (future) to rebuild `docs/FIELD_SCHEMA.md`. Keep changes atomic.

## 9. CI Expectations
CI must pass prior to merge:
| Check | Purpose |
|-------|---------|
| Field schema validation | Ensures each field entry has fallback & `/Value` rules applied. |
| README Quickstart present | Confirms onboarding clarity. |
| CHANGELOG Unreleased present | Prevents missing placeholder before release. |
| External link HEAD requests | Flags broken resource links (non-blocking warning). |
| Expression audit (future) | Detects missing fallbacks, `/Value` misuse, unbalanced tokens. |

## 10. Review Roles
Add approvers in CODEOWNERS. Clinical stakeholder required for changes that add or modify clinical fields.

## 11. Rollback Procedure
1. Identify previous tag (e.g., `v0.1.1`).
2. Revert commit or restore prior export zip.
3. Open `fix/rollback-<tag>` branch documenting reason.
4. New PR with explanation and validation runs.

## 12. Large HTML String Editing Guidelines
- Prefer editing template (`tests/altered/altered_rawHTMLParameters.html`) before raw JSON.
- Regenerate `inputs_pretty` using `scripts/regenerate_inputs_pretty.ps1`.
- Avoid introducing multiline indentation that could break tokenization.
- After edits, run upcoming `scripts/audit-compose.ps1` (once implemented) to validate expressions.

## 13. Adding New Fields
1. Add to SharePoint list.
2. Capture sample run JSON to confirm path (`/Value` presence).
3. Add config entry; generate docs; add expression with fallback.
4. Validate with populated + null test runs.

## 14. Questions / Clarifications
Open an issue with type Documentation or Enhancement. Provide context, sample run ID, and intended change scope.

---
_Last updated: 2025-11-07_
