---
name: HBPC Admission Flow Issue Report (Power Automate)
about: Report a defect, regression, data integrity issue, or enhancement need specific to the HBPC Admission HTML Compose action.
title: "[HBPC Admission] <Short Summary of Issue>"
labels: [needs-triage]
assignees: []
---

# HBPC Admission Flow Issue Template

> Please complete ALL applicable sections. Leave demographic fields blank if you are not the original VA employee reporter (they will be filled in during triage). Incomplete critical sections may delay resolution.

## 1. Reporter Demographics (VA Employee)
- Employee Name:
- Title / Role:
- Team / Service Line:
- Work Email Address (@va.gov preferred):
- Office / Location (Facility + City/State):
- Phone / Extension (optional):
- Date/Time Reported (Local CST):
- Time Zone of Reporter:
- Is Reporter a Flow Co-Owner? (Yes/No)

## 2. Issue Classification
- Type (Select one): Bug | Data Loss | Regression | Performance | Security | Compliance | Enhancement | Documentation
- Severity (Initial): Critical | High | Medium | Low
- Patient Safety Impact? (Yes/No/Unknown) If Yes, describe:
- PHI/PII Exposure Risk? (Yes/No/Unknown) If Yes, describe mitigation:
- Operational Impact Summary (1–2 sentences):

## 3. Flow Context
- Flow Name (UI Display): HBPC New Admission Email With Saved Form
- Flow Internal ID / GUID (if known):
- Environment Name (e.g., PROD, DEV, Sandbox):
- Solution Name (if packaged):
- Last Known Working Run ID (copy from Run History):
- First Observed Failing Run ID:
- Compose Action Name / Step Identifier:
- Trigger Type (e.g., When an item is created):
- SharePoint Site URL:
- SharePoint List Name:
- List Item ID(s) Impacted:
- Connectors Used (tick): SharePoint | Office 365 Outlook | Data Operations | Others:
- Dependent Child Flows or Parent Flows (list):

## 4. Affected Sections (Check all that apply)
- [ ] Summary Section
- [ ] Patient Information
- [ ] Social & Living Situation
- [ ] Medical Information
- [ ] Functional Assessment
- [ ] Activities of Daily Living (ADL)
- [ ] Continence Assessment
- [ ] Behavioral & Cognitive Assessment
- [ ] Admission Details
- [ ] Footer / Metadata
- [ ] Styling / CSS

## 5. Field-Level Data Impact (List internal names)
| Field Internal Name | Expected Value | Actual Value | Missing? (Y/N) | Notes |
|---------------------|---------------|--------------|----------------|------|
| Vision | | | | |
| Hearing | | | | |
| ExpressiveCommunication | | | | |
| ReceptiveCommunication | | | | |
| ADLBathingorShower | | | | |
| ADLDressing | | | | |
| ADLUsingToilet | | | | |
| ActivitiesOfDailyLiving | | | | |
| ADLEating | | | | |
| ADLWalking | | | | |
| ContinenceBowel | | | | |
| Continence | | | | |
| Mobility | | | | |
| AdaptiveTasks | | | | |
| BehaviorProblems | | | | |
| DisorientationMemoryImpairment | | | | |
| DisturbanceOfMood | | | | |
| CaregiverLimitations | | | | |
| HBHCAdmissionDate | | | | |
| PatientAddress | | | | |
| PreferredPhoneNumber | | | | |
| AdmissionType | | | | |
| LevelOfCare | | | | |
| HBPCAdmittingMDTeam | | | | |
| HBPCPrimaryNurse | | | | |
| EmergencyPlanPriorityLevel | | | | |
| DoesTheVeteranUse | | | | |

(Add additional rows as required)

## 6. Reproduction Steps
1. Step 1:
2. Step 2:
3. Step 3:
4. Result:

## 7. Expected vs Actual
- Expected Full Behavior (concise paragraph):
- Actual Behavior (concise paragraph):
- Percentage of HTML Missing / Corrupted (estimate):

## 8. Attachments & Evidence
- Screenshots (run history, email body, HTML diff):
- Raw HTML Failing Output File Name:
- Raw HTML Successful Reference File Name:
- Exported Flow Package (failing) filename:
- Exported Flow Package (successful) filename:
- Run History Diagnostic Links:

## 9. Timeline of Events
| Date/Time (CST) | Event | Actor | Notes |
|-----------------|-------|-------|-------|
| | Issue first observed | | |
| | Last known good run | | |
| | Attempted fix / edit | | |
| | Escalation / triage | | |

## 10. Suspected Root Cause
- Preliminary Hypothesis:
- Changed Elements (list perceived edits):
- Was AI-assisted editing used? (Yes/No/Unknown)
- Any solution export / import operations prior? (Yes/No)

## 11. Expression Integrity Review
| Expression Sample | Status (OK/Invalid) | Notes |
|-------------------|---------------------|-------|
| if(empty(outputs('Get_item')?['body/Vision/Value']), 'Not provided', ...) | | |
| if(empty(outputs('Get_item')?['body/ADLDressing/Value']), 'Not provided', ...) | | |
| formatDateTime(convertTimeZone(outputs('Get_item')?['body/Created'], 'UTC','Central Standard Time'),'MM/dd/yyyy hh:mm tt') | | |

(Add rows for each failing expression)

## 12. Compliance & Privacy Checklist
- Contains PHI/PII Fields? (Y/N) If yes, list:
- Verified no PHI in attachments/screenshots? (Y/N)
- Secure transmission path used? (Y/N)

## 13. Impact Assessment
- Affected Veteran Records (#):
- Affected Staff Workflows (# of users):
- Operational Delay (estimated hours):
- Risk if unresolved (brief):

## 14. Interim Mitigations Applied
- Manual data extraction from SharePoint? (Y/N)
- Temporary fallback email template? (Y/N)
- Manual nurse notification workflow? (Y/N)

## 15. Final Remediation (to be filled post-fix)
- Sections Restored:
- Field Rows Restored (count):
- Expression Pattern Adopted: if(empty(...)) with /Value dereferencing
- Fallback Text Standardized: "Not provided"
- Readability Enhancements: inputs_pretty array + lint notes
- Commit / Change Reference (file & timestamp):

## 16. Post-Fix Validation
| Test Case | Input Condition | Expected | Actual | Pass/Fail |
|-----------|-----------------|----------|--------|-----------|
| Null Choice Field | Vision empty | Displays "Not provided" | | |
| Populated ADL Field | ADLEating value present | Shows exact value | | |
| Date Formatting | Created date present | MM/dd/yyyy hh:mm tt + CST | | |
| Multi-section Rendering | All sections present | 5 restored sections | | |

## 17. Preventative Actions
- Introduce source control for flow JSON exports (Y/N planned date):
- Implement automated expression audit script (Y/N):
- Add version tag to Compose action (Y/N):
- Scheduled monthly environment export (Y/N):

## 18. Triage & Assignment (Internal Use)
- Triage Owner:
- Assigned Engineer:
- SLA Target Date:
- Escalation Level (None / Supervisor / IT Security / Clinical Informatics):
- Resolution Date:
- Close Code (Fixed / Not Reproducible / Duplicate / Won't Fix / Deferred):

## 19. Additional Notes / Commentary
> Free-form space for contextual details, cross-team coordination notes, or dependencies.

## 20. Checklist Before Submission
- [ ] All mandatory fields completed or marked N/A
- [ ] Sensitive data reviewed
- [ ] Reproduction steps clear
- [ ] Attachments referenced exist

---
Thank you for contributing to HBPC Admission Flow quality. Precise detail accelerates safe remediation.
