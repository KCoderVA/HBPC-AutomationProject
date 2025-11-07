# Copilot Instructions for HBPC Admission Flow Repository

## Purpose
This document guides AI pair-programming (GitHub Copilot / Chat) interactions in this repository to ensure: 
- Consistent automation-first practices (no manual local scripts unless explicitly required)
- Preservation of clinical governance, PHI safeguards, and deterministic outputs
- Minimal noise in diffs (avoid broad reformatting)
- Incremental, verified changes (green CI at each step)

## Repository Domains & Priorities
| Domain | Priority | Rationale |
|--------|----------|-----------|
| Flow Reconstruction Integrity | High | Avoid regression in restored mid-body HTML & expressions. |
| Schema Accuracy (`config/fieldSchema.json`) | High | Drives metrics, governance, badge & documentation. |
| Automation Workflows (CI / Release) | High | Source of truth for dynamic content and validations. |
| Governance & Compliance Docs | Medium | Must remain aligned with automated markers (policy version hash). |
| Documentation Indexing / TOCs | Medium | Aids discoverability; auto-generated sections should not be hand-edited. |
| Visualization Artifacts (Badges / Velocity Sparkline) | Medium | Informational; correctness > styling. |

## Automation Principles
1. Prefer editing existing workflow steps instead of creating new workflows unless scope is distinct (e.g., nightly jobs).
2. All generated content must use clear BEGIN/END comment markers to allow idempotent replacement.
3. Never introduce a tool that requires manual local invocation when a GitHub Actions step can perform the same function.
4. Use language-native shell/PowerShell; avoid adding new runtime dependencies (Python/Node) unless justified by complexity.
5. Keep JSON outputs stable: preserve ordering (auto-sort fields by `internalName`).

## Markers & Their Contracts
| Marker | File | Contract | Replacement Rule |
|--------|------|----------|------------------|
| `<!-- BADGES:START -->` / `<!-- BADGES:END -->` | `README.md` | Contains inline badges including Schema Field count. | Regex replace numeric count only. |
| `<!-- BUILDINFO:START -->` / `<!-- BUILDINFO:END -->` | `README.md` | Build metrics line. | Entire block replaced atomically. |
| `<!-- SCHEMA-SUMMARY:START -->` / `<!-- SCHEMA-SUMMARY:END -->` | `docs/FIELD_SCHEMA.md` | Generated schema table. | Full block regeneration from `fieldSchema.json`. |
| `<!-- POLICY-VERSION:START -->` / `<!-- POLICY-VERSION:END -->` | `GOVERNANCE.md` | Policy version + content hash. | Hash recalculated; version increments if hash differs. |
| `<!-- TOC:START -->` / `<!-- TOC:END -->` | Long docs | Auto-generated table of contents. | Rebuilt from headings (H2–H6). |
| `<!-- VELOCITY-TREND:START -->` / `<!-- VELOCITY-TREND:END -->` | `docs/CHANGE_VELOCITY_LOG.md` | Sparkline + recent metrics table. | Recomputed on tag push. |

## Validation Expectations
Before finishing an automated change batch:
- YAML workflows must parse (avoid heredocs that confuse YAML; prefer printf or inline multi-line strings)
- CI steps should be idempotent (second run without input changes yields no diff/commit)
- Regex patterns must be Singleline-aware when spanning blocks (use `(?s)` or PowerShell `[regex]::Replace` with `Singleline` option)

## Expression Pattern Rules (Compose JSON)
| Rule | Description | Example |
|------|-------------|---------|
| Fallback Consistency | Use `if(empty(...),'Not provided',...)` pattern | `@{if(empty(outputs('Get_item')?['body/Vision/Value']), 'Not provided', outputs('Get_item')?['body/Vision/Value'])}` |
| Choice Fields | Append `/Value` to internal name path | `...['body/PreferredLanguage/Value']` |
| Non-Choice Fields | No `/Value` suffix | `...['body/AdmissionDate']` |
| No Legacy `coalesce()` | Replace with explicit `if(empty(...))` | (Remove) `coalesce(field,'Not provided')` |
| Balanced Tokens | All `@{` must have matching `}` | Audited by CI `Expression audit` step |

## Commit Message Guidance
Use Conventional Commits with scoped clarity:
- `feat(ci): add expression audit step`
- `chore(readme): refresh build info (abc1234)`
- `docs(schema): refresh schema summary table`
- `fix(flow): correct fallback for AdmissionDate`

Avoid generic messages like `update file` or `misc fixes`.

## When Adding a New Metric
1. Compute inside existing relevant step if logically adjacent (prefer fewer steps).
2. Update only necessary blocks (BADGES, BUILDINFO, VELOCITY-TREND).
3. Add a field to `metrics/build-manifest.json` (ensure backward compatibility — do not remove fields without version note).
4. Reflect additional reference (if user-facing) in README Build Info line.

## Adding New Fields to Schema
1. Append field object (temporary order fine — CI will auto-sort).
2. Ensure required properties: `internalName`, `displayLabel`, `section`, `category`, `dataType`, `fallback`.
3. For choice fields set `choice=true` and `requiresValueSuffix=true`.
4. Run CI; ensure badge & summaries update automatically.

## Safe Editing Checklist (AI Actions)
| Item | Check |
|------|-------|
| Workflow Changed | Validate no indentation / quoting issues. |
| Uses Markers | Confirm only within marker range modifications. |
| JSON Edited | Validate with `ConvertFrom-Json` (PowerShell) conceptually (no trailing commas). |
| Schema Updated | Ensure fallback present & sensitivity enumerated. |
| Docs Touched | If headings changed, allow TOC regeneration step to run. |
| Governance Changed | Expect policy version bump next CI run. |

## Anti-Goals
- Do NOT reformat entire files (preserve existing diff minimalism).
- Do NOT introduce runtime dependencies for simple text processing.
- Do NOT manually edit generated blocks rather than updating their sources.
- Do NOT expose PHI or create sample data containing real identifiers.

## Escalation / Clarification Strategy
If ambiguity arises (e.g., unknown field classification):
1. Infer from existing schema categories where reasonable.
2. Insert a `notes` property explaining assumption.
3. Surface a concise TODO in PR description (not inline code comment clutter).

## Performance & Idempotency
- Steps that might commit (badge update, schema summary) must exit cleanly when no changes — rely on `git commit ... || echo 'No changes'` pattern.
- Avoid multiple commits in a single workflow run for related artifacts unless separation clarifies intent.

## Typical Enhancement Flow (AI)
1. Read target files (`.github/workflows/*.yml`, schema, README) for context.
2. Apply minimal patch (single tool call) grouping related edits.
3. Re-run YAML validation mentally (avoid heredocs — prefer `printf`).
4. Stage & commit with scoped message.
5. Suggest follow-up micro-improvements (explicitly mark as optional).

## Glossary
| Term | Meaning |
|------|---------|
| Mid-Body Reconstruction | Restored HTML sections originally lost in failing flow version. |
| Velocity Log | `docs/CHANGE_VELOCITY_LOG.md` summarizing release cadence and schema growth. |
| Sparkline | Unicode bar mini-graph of recent schema field counts. |
| Policy Version Hash | SHA256 of `GOVERNANCE.md` content sans marker to drive version increment. |

## Future-Proofing Recommendations
- If schema complexity grows ( > 50 fields ), consider splitting into categorized arrays then re-aggregating in CI for docs.
- Introduce severity levels for expression audit findings (warn vs fail) using a simple severity prefix.
- Add optional SARIF output for audits to annotate PRs directly.

## AI Interaction Examples
Scenario: Add a new choice field `CareSetting`.
1. Append object to `fieldSchema.json` with `choice=true`, `requiresValueSuffix=true`.
2. Commit with `feat(schema): add CareSetting field`.
3. Rely on CI to: auto-sort, update badge, rebuild summary table.
4. Verify velocity log updates at next tag.

Scenario: Add a metric (average files changed last 3 releases).
1. Extend release workflow metric step; compute rolling mean from velocity log.
2. Add to `metrics/build-manifest.json`.
3. Inject into velocity trend table (new column) with backward-compatible header update.

## Concluding Notes
This file itself should remain mostly static—update only when introducing new marker types, validation domains, or process shifts. Treat it as a contract between maintainers and AI automation.

_Last updated: 2025-11-07_
