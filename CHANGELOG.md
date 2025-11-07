# CHANGELOG

All notable changes to the HBPC Admission Compose action & supporting artifacts.

## 2025-11-06
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
