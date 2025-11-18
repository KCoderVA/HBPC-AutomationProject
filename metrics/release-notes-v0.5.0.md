# Release Notes v0.5.0 (2025-11-18)

## Overview
Adds HBPC Discharge flow remediation and documentation artifacts alongside existing Admission flow governance and reconstruction materials.

## Added
- Discharge flow stage `test1_Success` artifacts (inputs, outputs, raw parameters, peek raw code, commit logs, remediation report, issue records, export zip).
- Architecture documentation updated to dual-flow model.
- CHANGELOG entry for v0.5.0 and new Unreleased scaffold.
- Velocity log rows for v0.4.0, v0.4.1, v0.5.0.

## Fixed
- Missing Discharge summary fields (Marital Status, Usual Living Arrangements) now present with fallback logic.

## Changed
- README build info and artifact table reflect both flows; commit hash updated.

## Integrity
- Pre-commit PHI safeguards remain in place (temporarily disable via rename if needed).
- Export package present for Discharge remediation (`exports/flow_export.zip`).

## Metrics Snapshot
- Files Changed: 13
- Schema Fields: 11 (unchanged)

## Next (Unreleased Targets)
- Admission top-section fallback normalization
- Placeholder artifact retirement (baseline & pending test stages)
- Automated expression + placeholder audit scripts

---
Generated automatically as part of v0.5.0 release consolidation.
