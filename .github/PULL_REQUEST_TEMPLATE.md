---
name: HBPC Admission Flow Pull Request
about: Submit changes to the Power Automate HBPC Admission HTML Compose logic or related artifacts.
title: "[HBPC Admission] <Concise Change Summary>"
labels: [review, hbpc-flow]
assignees: []
---

## 1. Summary
Describe the change in 2–3 sentences. Reference any issue IDs (e.g., #123) and specify if this is remediation, enhancement, or maintenance.

## 2. Change Type
- [ ] Bug Fix
- [ ] Enhancement / Feature
- [ ] Refactor / Cleanup
- [ ] Performance
- [ ] Documentation
- [ ] Security / Compliance
- [ ] Other:

## 3. Flow Components Modified
| Component | Action (Add/Update/Remove) | Notes |
|-----------|----------------------------|-------|
| Compose (Admission HTML) | | |
| Trigger (SharePoint) | | |
| Get Item | | |
| Additional Actions | | |

## 4. Sections Affected
- [ ] Summary
- [ ] Patient Information
- [ ] Social & Living Situation
- [ ] Medical Information
- [ ] Functional Assessment
- [ ] ADL
- [ ] Continence
- [ ] Behavioral & Cognitive
- [ ] Admission Details
- [ ] Footer
- [ ] Styling / CSS

## 5. Dynamic Field Changes
List any internal SharePoint field names added/removed/renamed or /Value path changes.

## 6. Expression Changes
| Original Expression (if modified) | New Expression | Reason |
|-----------------------------------|----------------|--------|
| | | |

## 7. Fallback & Null Handling
Confirm all added fields use `if(empty(...),'Not provided', ...)` or document exceptions.

## 8. Data/PHI Considerations
- PHI Added/Removed? (Y/N) If yes, specify.
- Any new sensitive fields? (Y/N)
- Screenshots scrubbed of PHI? (Y/N)

## 9. Validation Checklist
- [ ] Flow exports successfully without errors
- [ ] Compose action saves without invalid expression errors
- [ ] Test run with populated data (Run ID: )
- [ ] Test run with sparse/null data (Run ID: )
- [ ] HTML renders all intended sections
- [ ] Fallback text appears for empty fields
- [ ] Date/time formatting correct (CST)
- [ ] No unintended JSON fragments displayed

## 10. Screenshots / Artifacts
Attach or reference:
- Successful HTML output file name
- Failing (pre-fix) HTML output file name
- Diff snippet (optional)

## 11. Rollback Plan
Briefly describe how to revert (include prior export .zip package name or previous commit reference).

## 12. Post-Deployment Monitoring
Define 2–3 items to monitor (e.g., error runs, missing field counts, email size).

## 13. Risks & Mitigations
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| | | | |

## 14. Dependencies
List any SharePoint schema changes, solution imports, or external connectors required.

## 15. Governance Compliance
- Version tag updated? (Y/N)
- Export archived? (Y/N)
- Report updated (quick/verbose)? (Y/N)

## 16. Additional Notes
Free-form notes, context, or out-of-scope follow-ups.

## 17. Approvals
| Role | Name | Approval Date |
|------|------|--------------|
| Engineer | | |
| Clinical/Operational Stakeholder | | |
| Security/Compliance (if required) | | |

## 18. Checklist Before Merge
- [ ] All validation items passed
- [ ] Rollback plan documented
- [ ] Risks assessed
- [ ] Governance items complete
- [ ] Issue(s) linked

---
Submitting this PR acknowledges adherence to internal HBPC Flow standards and safeguards for patient data integrity.
