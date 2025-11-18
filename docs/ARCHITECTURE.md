# HBPC Admission & Discharge Flows Architecture

<!-- TOC:START -->
1. Architecture Diagram
2. Components
3. Data Flow Highlights
4. Extension Points
<!-- TOC:END -->

```mermaid
graph TD
  A1[Admission Item Created] --> B1[Admission Trigger]
  B1 --> C1[Admission Get Item]
  C1 --> D1[Compose Admission HTML]
  D1 --> E1[Send Admission Email]
  C1 --> F1[(Future Admission Validation)]
  D1 --> G1[inputs_pretty Mirror Generation]
  E1 --> H1[(Audit Logging / PHI Safeguards)]
  A2[Discharge Item Created] --> B2[Discharge Trigger]
  B2 --> C2[Discharge Get Item]
  C2 --> D2[Compose Discharge HTML]
  D2 --> E2[Send Discharge Email]
  C2 --> F2[(Future Discharge Validation)]
  D2 --> G2[Discharge Remediation Rows]
  E2 --> H2[(Audit Logging / PHI Safeguards)]
  subgraph Shared
    S1[Field Schema Config]
    S2[Governance & CI]
    S3[Release & Tagging]
  end
  D1 --> S1
  D2 --> S1
  S1 --> S2
  S2 --> S3
```

## Components
| Step | Description | Notes |
|------|-------------|-------|
| Trigger | SharePoint list item created/modified | Source of initial context |
| Get Item | Retrieves full field payload | Normalized access path `outputs('Get_item')` |
| Compose (Admission) | Builds Admission HTML with unified fallback pattern | Central reconstruction target (mid-body restoration) |
| Compose (Discharge) | Builds Discharge HTML with remediated summary rows | Recent remediation (v0.5.0) |
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

## Canvas App Integration (v0.5.1)
The Canvas App (`HinesHBPCAdmDisApp`) now provides structured data capture feeding Admission & Discharge flows. Key architectural roles:

| Element | Role | Notes |
|---------|------|-------|
| OnStart (App.fx.yaml) | Initializes required field collections & responsive layout vars | Prepares validation sets (Inpatient vs Outpatient) |
| MainFormAdmission | Admission-specific data entry & conditional sections | Drives flow trigger payload completeness |
| MainFormDischarge | Discharge data entry with remediation fields | Ensures remediation parity with flow summary rows |
| Themes.json | Central styling tokens | Uniform visual identity across screens |
| CanvasManifest.json | Feature flags & compatibility | Documents enabled experimental features (e.g., nativecdsexperimental) |

Data lineage: User input -> Canvas App collections / controls -> SharePoint list item -> Power Automate trigger -> Compose HTML reconstruction.

_Canvas integration recorded: 2025-11-18 (v0.5.1)_

_Last updated: 2025-11-18_
