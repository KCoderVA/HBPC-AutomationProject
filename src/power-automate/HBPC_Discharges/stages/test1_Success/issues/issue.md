<!-- Issue Template: HBPC Discharge Flow Missing Summary Fields (test1_Success) -->

# HBPC Discharge Flow – Missing "Marital Status" & "Usual Living Arrangements" Summary Rows

## 1. Reporter Information
- Name:
- Role / Title:
- Team:
- Contact Email / Extension:
- Date Reported (CST):

## 2. Flow Context
- Flow Name: HBPc Discharge Notification
- Environment: (Default / Production)
- Trigger: SharePoint (When an item is created)
- Compose Action: Save-HTML-Document
- Stage: test1_Success

## 3. Problem Summary
Generated discharge HTML and email omitted two required fields from the summary table: Marital Status and Usual Living Arrangements.

## 4. Impact
- Data Completeness: Social context partially missing.
- Operational: Staff manually opened SharePoint item to retrieve absent data.
- Patient Safety: None.

## 5. Root Cause (Preliminary)
- Template cloning from Admissions test5_partialSuccess lacked insertion of these two rows.
- No checklist or automated validator to confirm required summary fields.

## 6. Reproduction Steps
1. Create new discharge item with Marital Status + Usual Living Arrangements populated.
2. Allow flow to run.
3. Open generated HTML/email.
4. Observe missing rows.

## 7. Expected vs Actual
- Expected: Both fields appear with values or fallback text.
- Actual: Rows absent entirely.

## 8. Fix Summary
Added two <tr> blocks (lines 242–249) in raw_parameters_originalVerbose.html with standard fallback expression: if(empty(field),'Not specified', parsed value).

## 9. Validation
- Test run with populated fields – values display.
- Test run with empty fields – fallback displays.
- Layout confirmed intact in compose_outputs.

## 10. Attachments / Artifacts
- raw_parameters_originalVerbose.html (updated)
- compose_inputs / compose_outputs (before/after review)
- verbose_commit_originalSource.txt
- verbose_report_originalSource.md

## 11. Recommendations
- Add summary field checklist to governance docs.
- Implement automated HTML row presence validator.
- Harmonize extraction pattern away from split()/contains() to direct /Value where applicable.

## 12. Status
- Resolution: Fixed.
- Date Fixed:
- Verified By:

---
Use this template to file or audit the issue; see issue_filled_originalSource.txt for completed example.