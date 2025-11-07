# Governance & Versioning

## Purpose
Defines how changes are proposed, reviewed, versioned, and audited for the HBPC Admission Flow artifacts.

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
2. Run export of updated flow; place zip in `tests/flowSuccess/`.
3. Promote `[Unreleased]` section in CHANGELOG via `scripts/changelog-finalize.ps1 -Version <x.y.z>`.
4. Tag: `git tag -a vX.Y.Z -m "vX.Y.Z: summary"` and push.
5. Create GitHub Release (optional) summarizing clinical impact & remediation notes.

## Branch Protection (Recommended)
- Require status checks (CI audit) to pass.
- Minimum 1 engineering + 1 clinical review for field changes.
- Disallow force pushes to `main`.

## Audit Artifacts
| Artifact | Purpose |
|----------|---------|
| Flow export zip | Source-of-truth snapshot for rollback. |
| altered_RawCodeView.json | Authoritative Compose action mid-body patterns. |
| FIELD_SCHEMA.md | Data dictionary and PHI classification. |
| CHANGELOG.md | Chronological human-readable history. |

## Deferred / Experimental Changes
Experimental branches (`exp/`) must not be merged without conversion to a standard branch prefix.

## Compliance Notes
- Mask identifiers in all long-lived documentation unless essential for structural accuracy.
- Retain previous two successful export zips for historical diff (space permitting).

## Deprecation Policy
- Announce impending removal of fields via issue labeled `deprecation` at least one minor version before removal.

## Incident Response (Flow Break / Data Loss)
1. Open critical issue with run IDs & scope.
2. Branch `fix/incident-<short-key>`.
3. Restore from last known good zip if reconstruction exceeds SLA.
4. Document in CHANGELOG under `Fixed` subsection.

---
_Last updated: 2025-11-07_
