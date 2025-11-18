# Issue & PR Labels

Standard labels to classify work and aid triage.

| Label | Purpose | Usage Guidance |
|-------|---------|----------------|
| schema | Field schema changes or additions | Any modification to `docs/config/fieldSchema.json` |
| expression | Flow expression normalization | Adjusting fallback or dereferencing patterns |
| compliance | Security / PHI / license adherence | Touches `SECURITY.md` or license headers |
| release-blocker | Must be resolved before tagging | Critical regression or missing required audit |
| enhancement | New capability, doc, or script | Non-defect functional improvements |
| hotfix | Emergency patch branch work | Linked to `hotfix/` branch naming |
| governance | Playbook / process / policy docs | Changes in `RELEASE.md` or `GOVERNANCE.md` |
| performance | Optimization of processing time | Future automation scripts metrics |
| docs | Documentation only | Pure markdown/text updates |

## Conventions
- Prefer one primary label; add secondary only if materially helpful.
- Remove `release-blocker` immediately once resolved.
- `hotfix` implies accelerated review.

## Future Automation
A lightweight script may validate that any change to `fieldSchema.json` includes the `schema` label in its PR body.

_Last updated: 2025-11-07_
