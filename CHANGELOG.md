# [v0.5.0] - 2025-11-18
### Added
- HBPC Discharge Power Automate flow documentation and artifacts (see `src/power-automate/HBPC_Discharges/stages/test1_Success`).
- Remediation report and commit logs for Discharge flow bug fix (missing Marital Status and Usual Living Arrangements fields).
### Fixed
- Discharge flow Compose action now includes all required summary fields; validated fallback and rendering logic.
### Changed
- Updated README, architecture, and artifact tables to reflect new Discharge flow and v0.5.0 release.

## [Unreleased]
### Added
- (placeholder)
### Changed
- (placeholder)
### Fixed
- (placeholder)

# CHANGELOG

All notable changes to the Veteran Admission Compose action & supporting repository artifacts.
<!-- PHI MASKED: All example names replaced with 'Veteran' -->


## [v0.4.1] - 2025-11-18
### Added
- Pre-commit hook now blocks only PHI identifier prefixes (Patient Name, Name, Veteran Name, etc.)
### Changed
- README.md build info and last updated date refreshed for latest commit
### Fixed
- Expression audit artifacts populated; workspace file references aligned; duplicate Unreleased section removed

## [v0.4.0] - 2025-11-07
### Added
- Source tree replacement adopting new namespace `src/power-automate/` with enriched stage evidence (exports, issues, metadata, verbose artifacts).
- Diff tooling scripts: `generate-src-new-manifest.ps1`, `src-new-metrics.ps1`, `diff-src-manifests.ps1`, tests diff scripts, and metrics capture utilities.
- Forensic baseline artifacts (manifests, metrics, diff reports) preserved under `archives/` with new ignore policy.
- Relocated `copilot-instructions.md` to `.github/` for improved discovery by automation.
### Changed
- README artifact table updated for source namespace & Copilot relocation.
- CI path consistency check adjusted to expect `.github/copilot-instructions.md`.
- `.gitignore` now ignores `archives/` recursively and includes explicit `.git/` entry (clarity).
### Fixed
- Removed outdated dev path expectation for Copilot instructions in CI consistency validation.

## [v0.3.0] - 2025-11-07\n### Added\n- (none)\n\n### Changed\n- (none)\n\n### Fixed\n- (none)\n\n
### Added
- Tracked historical flow export `.zip` packages (success & failure) by removing `*.zip` from `.gitignore`.
- Expanded `README.md` with architecture diagram, governance workflow, troubleshooting matrix, and zip tracking rationale.
### Changed
- Updated `.gitignore` comments to retain tar/gz ignores but include zip exports.
### Documentation
- Clarified regeneration process for `inputs_pretty` and future governance roadmap.

## [0.1.0] - 2025-11-06
### Added
- Restored five missing HTML sections (Functional, ADL, Continence, Behavioral/Cognitive, Admission Details).
- Implemented uniform expression pattern with explicit `if(empty(...),'Not provided', value)`.
- Added `/Value` dereferencing for choice/complex fields.
- Introduced readability aids: `inputs_pretty` array, `lint_notes` metadata.
- Created comprehensive forensic report (`FLOW_RECONSTRUCTION_REPORT.md`).
- Added quick summary report (`FLOW_RECONSTRUCTION_REPORT_QUICK.md`).
- Added verbose and quick commit messages.
- Added GitHub issue & pull request templates.
- Added sample filled issue file for retrospective documentation.
- Added field schema placeholder (`FIELD_SCHEMA.md`).
- Added regeneration script for `inputs_pretty`.

### Changed
- Normalized mid-section dynamic field references to `outputs('Get_item')` structure.
- Improved null handling consistency and reduced parser ambiguity.

### Fixed
- Malformed ADLDressing expression.
- Truncation resulting in loss of mid-body dynamic sections.

### Notes
- Source control adoption and automated integrity auditing pending.
- Top sections still use original `coalesce()` approach; consider normalization in next release.

---
Version numbering begins at 0.1.x for post-reconstruction baseline; future semantic version tags (e.g., 0.2.0) will represent structural or governance feature additions.
