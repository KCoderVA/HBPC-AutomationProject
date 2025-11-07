# Copilot Quick Reference (HBPC Admission Flow)

Use this as a concise checklist; defer to `copilot-instructions.md` for full detail.

## 1. Markers
- BADGES, BUILDINFO, SCHEMA-SUMMARY, POLICY-VERSION, TOC, VELOCITY-TREND: never remove markers.
- Replace only inside marker spans; keep outer comments intact.
- Governance hash bump handled automatically.

## 2. Workflows
- CI ensures schema, CHANGELOG Unreleased headings, commit prefix, SPDX, expression audit.
- Release workflow auto-updates badge, velocity log, release notes, CHANGELOG.
- Avoid heredocs—prefer `printf` for inline JSON or SVG.

## 3. Schema Field Add/Edit
- Required: internalName, displayLabel, section, category, dataType, fallback.
- Choice fields: `choice=true`, `requiresValueSuffix=true`.
- Order doesn't matter—CI auto-sorts.

## 4. Expression Pattern
```
@{if(empty(outputs('Get_item')?['body/<InternalName>/Value']), 'Not provided', outputs('Get_item')?['body/<InternalName>/Value'])}
```
- No `coalesce()`. Omit `/Value` for plain text/DateTime.
- Balanced `@{` and `}` tokens.

## 5. Commits / Tags
- Conventional prefixes: feat|fix|chore|docs|refactor|security|perf|test|build|ci.
- Tag format: `vMAJOR.MINOR.PATCH` (optionally `-rc.N`).
- Summaries < 72 chars, no trailing punctuation at prefix end.

## 6. CHANGELOG Discipline
- Maintain `## [Unreleased]` with headings (Added / Changed / Fixed).
- Release finalize step converts Unreleased → version section + reinserts skeleton.
- Do not delete older sections.

## 7. Safety Checklist
- Before commit: YAML valid, markers intact, schema fallbacks present.
- After changes: run CI or trust automation; no manual badge edits.
- Governance edits expect version hash bump next CI run.

## 8. PHI Safeguards
- No real names, addresses, phone numbers, SSNs.
- CI warns on heuristic matches; treat warnings seriously.
- Mask examples (e.g., `XXX-XX-1234`, `555-555-0000`).

## 9. Release Flow (Summary)
1. Ensure CHANGELOG Unreleased updated.
2. Tag commit (`git tag -a vX.Y.Z -m "vX.Y.Z: summary"`).
3. Push tag; automation updates badge, velocity log, release notes, CHANGELOG.
4. Unreleased skeleton regenerated automatically.

## 10. Avoid False Positives
- Keep placeholder words (`Veteran`, `Not Provided`) for samples.
- For structural doc edits, commit separately; large rewrites may trigger name heuristic.
- Downgrade new strict checks to warning-only first.

_Last updated: 2025-11-07_
