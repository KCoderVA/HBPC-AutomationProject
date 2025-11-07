# Governance & Versioning
<!-- POLICY-VERSION:START -->Policy Version: 1 (hash: INIT)<!-- POLICY-VERSION:END -->

## Purpose
Defines how changes are proposed, reviewed, versioned, and audited for the HBPC Admission Flow artifacts. Licensed under Apache 2.0 (see `LICENSE.txt`). Joint Copyright © 2025 Kyle J. Coder & Ara A. Zakarian.

## Roles
| Role | Responsibilities |
|------|------------------|
| Engineering Maintainer | Implements approved changes, maintains scripts/CI. |
| Clinical Stakeholder | Validates clinical field semantics & presentation. |
| Compliance/Security | Ensures PHI handling & logging practices. |

## Versioning Model (Semantic)
MAJOR.MINOR.PATCH
- MAJOR: Structural HTML section redesign, removal or splitting of existing sections.
- MINOR: New fields, new sections, new governance automation, expression pattern shifts.
- PATCH: Non-breaking expression normalization, documentation updates, small script fixes.

## Release Flow
1. Merge changes to `main` after PR approval.
2. Run export of updated flow; place zip in `tests/flowSuccess/` with timestamped name (retain latest 3 success & 3 failure exports).
3. Run expression audit script (pending implementation) – must pass.
4. For pre-release stabilization use tags: `vX.Y.Z-rc.N` (release candidates) prior to final.
5. Promote `[Unreleased]` section in CHANGELOG via `scripts/changelog-finalize.ps1 -Version <x.y.z>`.
6. Tag final: `git tag -a vX.Y.Z -m "vX.Y.Z: summary"` and push.
7. Create GitHub Release (optional) summarizing clinical impact & remediation notes.

## Branch Protection (Recommended)
- Require status checks (CI workflow) to pass.
- Minimum 1 engineering + 1 clinical review for field changes.
- Disallow force pushes & direct merges (require PR).

## Audit Artifacts
| Artifact | Purpose |
|----------|---------|
| Flow export zip | Source-of-truth snapshot for rollback. |
| altered_RawCodeView.json | Authoritative Compose action mid-body patterns. |
| FIELD_SCHEMA.md | Data dictionary and PHI classification. |
| CHANGELOG.md | Chronological human-readable history. |
| config/fieldSchema.json | Machine-readable schema scaffold for automation. |
| CI workflow (ci.yml) | Validates schema, README Quickstart, CHANGELOG Unreleased presence. |

## Deferred / Experimental Changes
Experimental branches (`exp/`) must not be merged without conversion to a standard branch prefix.

## Compliance Notes
- Mask identifiers in all long-lived documentation unless essential for structural accuracy.
- Retain latest 3 successful AND 3 failure export zips for historical diff & regression forensics.
- Maintain offline encrypted backup of latest successful export monthly (manual until automated).

## Deprecation Policy
- Announce impending removal of fields via issue labeled `deprecation` at least one minor version before removal.

## Incident & Hotfix Response
Hotfix triggers: production regression, PHI exposure risk, missing critical section.
1. Open critical issue with run IDs & scope (label `release-blocker` + `hotfix`).
2. Run audit script to classify failure (missing sections vs expression errors).
3. Branch `hotfix/vX.Y.Z-hotfixN` from the last good tag.
4. Apply minimal corrective change; validate success + sparse runs.
5. Update CHANGELOG under `Fixed` subsection; if tag already published bump PATCH.
6. Document root cause & mitigation steps.
7. Consider offline backup refresh if structural correction.

_Last updated: 2025-11-07_
