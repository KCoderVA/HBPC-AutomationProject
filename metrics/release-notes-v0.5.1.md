# Release Notes v0.5.1 (2025-11-18)

## Overview
Introduces source-controlled Canvas App (HinesHBPCAdmDisApp) alongside existing Admission & Discharge flows to unify clinical data capture and pipeline transparency.

## Added
- Unpacked Canvas sources under `src/power-apps/.unpacked` (manifest, screens, themes, component refs).
- README + Architecture updates for dual-flow + app integration.
- CHANGELOG ordering fix (Unreleased moved to top) and v0.5.1 section.
- Velocity log row for v0.5.1.

## Changed
- Artifact table expanded with Canvas App assets.

## Fixed
- Documentation conventions (Unreleased placement) aligned with standard semantic changelog format.

## Integrity & Governance
- No schema field changes (still 11) – Canvas App introduces UI logic only.
- Experimental feature flags documented in `CanvasManifest.json`.
- OnStart collection logic captured for validation roadmap.

## Metrics Snapshot
- New Files (approx): 10 tracked (excluding binary msapp duplicate if already present).
- Schema Fields: 11 (unchanged).

## Next Targets (Unreleased)
1. Placeholder artifact retirement in baseline & test6 pending stages.
2. Automated Power Fx lint/audit (fallback + collection presence).
3. Flow/App synchronization script (compare required field lists vs HTML summary).
4. PHI pattern expansion for App source (ensure safe OnStart literals).

---
Generated automatically during v0.5.1 tag preparation.
