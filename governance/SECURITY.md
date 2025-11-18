# Security & PHI Handling

This repository may reference fields that can contain Protected Health Information (PHI). The goal is to prevent storage of raw PHI in source control while enabling development of transformations and audit logic.

## Scope
- Source artifacts (HTML, JSON, scripts)
- Documentation & examples
- Generated pretty input mirrors

## PHI Categories
| Category | Examples | Policy |
|----------|----------|--------|
| Direct Identifiers | Full Name, SSN, MRN | Never committed verbatim |
| Quasi Identifiers | Date of Birth, Zip Code | Use generalized / masked values |
| Clinical Data | Diagnoses, Lab Codes | Allowed if non-identifying and aggregated |

## Redaction & Masking Guidelines
- Replace SSNs with pattern: `***-**-XXXX` (last 4 optional).
- Names: use `John/Jane Doe` or role placeholders (`Patient A`).
- Dates: shift by ±N days (not implemented yet) or show month/year only.
- Addresses: keep city/state only; remove street lines.

## Repository Rules
1. No screenshots containing PHI.
2. No raw exported HTML with real patient values.
3. Use placeholders in examples (`Not provided`, `Sample Value`).
4. Scripts performing anonymization must default to dry-run.

## Reporting Potential Exposure
If PHI is accidentally committed:
1. Immediately create a `hotfix/` branch removing artifacts.
2. Force rebase if needed to excise sensitive commits (coordinate with admins).
3. Open an internal incident ticket referencing the commit hash.
4. Tag `SECURITY-INCIDENT-<date>` (lightweight annotation tag, not release).

## Future Automation
- Anonymization script (regex patterns for SSN, Phone, Emails).
- Pre-commit hook (optional future) to block common PHI patterns.
- Periodic scan with script to produce audit summary.

## Allowed Test Data Patterns
| Data Type | Allowed Form |
|-----------|--------------|
| SSN | 000-00-1234, ***-**-1234 |
| Phone | 555-0100, (555) 000-0000 |
| Email | example+test@local.invalid |
| MRN | MRN000123 (generic pattern) |

## Sensitive Field Tracking
Reference `docs/config/fieldSchema.json` field objects will include:
```json
{
  "name": "PatientFullSSN",
  "section": "Identity",
  "category": "DirectIdentifier",
  "sensitivity": "High"
}
```

## Verification Checklist (Manual)
- [ ] Added/modified files scanned for direct identifiers
- [ ] CHANGELOG additions contain only generalized references
- [ ] Scripts avoid embedding example PHI

---
_Last updated: 2025-11-07_
