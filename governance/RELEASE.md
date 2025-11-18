# Release Playbook

This document describes the manual release process (no CI dependency yet).

## 1. Pre-Release Checklist
- [ ] Working tree clean (`git status`)
- [ ] Field schema updated (`docs/config/fieldSchema.json`)
- [ ] Expression normalization (if planned) completed
- [ ] CHANGELOG has `[Unreleased]` section populated
- [ ] No PHI in newly added examples or docs
- [ ] Flow export run succeeds in environment

## 2. Version Selection
Semantic versioning (MAJOR.MINOR.PATCH):
- MAJOR: Structural HTML section or flow logic breaking changes
- MINOR: New sections, new fields, governance automation additions
- PATCH: Docs, scripts, expression standardization

Pre-release tags (optional): `v0.2.0-rc.1`, `v0.2.0-rc.2` for candidate stabilization; do not place final export until stable tag.

## 3. Steps
1. Run manual audits (scripts forthcoming): expression fallback, `/Value` paths.
2. Export flow → save as `docs/tests/flowSuccess/exportedSuccess_HBPCNewAdmissionEmailWithSavedForm_<UTCSTAMP>.zip`.
3. Update CHANGELOG `[Unreleased]` with final bullet points.
4. Run `./scripts/changelog-finalize.ps1 -Version <x.y.z>`.
5. Tag release: `git tag -a vX.Y.Z -m "vX.Y.Z: summary"`.
6. Push: `git push origin main --follow-tags`.
7. Open GitHub Release (optional) linking to reconstruction or governance notes.
8. Log entry in `docs/CHANGE_VELOCITY_LOG.md`.

## 4. Hotfix Procedure
Use when a critical regression or data omission is detected:
1. Branch `hotfix/vX.Y.Z-hotfixN` from tagged release.
2. Apply minimal corrective change; update CHANGELOG under Fixed.
3. Bump PATCH if non-breaking; if true rollback, retag with incremented PATCH.
4. Document root cause in release notes.

## 5. Rollback
- Identify last good tag & corresponding export zip.
- Re-import flow (environment-level) if necessary.
- Cherry-pick non-related commits if safe.

## 6. Post-Release Validation
| Check | Description | Status |
|-------|-------------|--------|
| Sample populated run | All sections present | |
| Sparse run | Fallbacks render | |
| Choice value extraction | `/Value` returns plain labels | |
| No stale PHI in repo | Spot audit performed | |

## 7. Metrics (Manual for now)
Track in velocity log:
- Files touched
- Fields modified
- New schema entries
- Time from code freeze to tag

---
_Last updated: 2025-11-07_
