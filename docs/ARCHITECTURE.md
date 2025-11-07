# HBPC Admission Flow Architecture

```mermaid
graph TD
  A[SharePoint Item Created] --> B[Trigger]
  B --> C[Get Item]
  C --> D[Compose Admission HTML]
  D --> E[Send Email Notification]
  C --> F[(Future) Validation Script]
  D --> G[inputs_pretty Mirror Generation]
  E --> H[(Audit Logging / PHI Safeguards)]
```

## Components
| Step | Description | Notes |
|------|-------------|-------|
| Trigger | SharePoint list item created/modified | Source of initial context |
| Get Item | Retrieves full field payload | Normalized access path `outputs('Get_item')` |
| Compose | Builds HTML with unified fallback pattern | Central reconstruction target |
| Send Email | Delivers clinical summary | Contains rendered HTML |
| inputs_pretty | Readability aid (non-executed) | Regenerated via script |
| Export Zips | Environment snapshot for rollback | Stored under `tests/flowSuccess/` & `tests/flowFailure/` |

## Data Flow Highlights
- Choice field resolution standardized with `/Value` to surface label text.
- Fallback text `Not provided` ensures visibility of absent data.
- Future validation hook can parse run output JSON to confirm field conformity before send.

## Extension Points
| Future Component | Purpose |
|------------------|---------|
| Validation Script | Pre-send verification of required fields & PHI masking |
| Expression Audit CI | Fallback + structure enforcement |
| Anonymization Tool | Redact PHI for troubleshooting outside secure boundary |

---
_Last updated: 2025-11-07_
