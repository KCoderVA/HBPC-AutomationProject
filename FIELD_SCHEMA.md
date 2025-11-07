# HBPC Admission Field Schema

> Populate this table with authoritative metadata for each SharePoint field referenced in the Compose action. This improves auditability, facilitates future refactors, and supports compliance reviews.

| Internal Name | Display Label | Data Type | Choice? (Y/N) | Uses /Value? | PHI/PII (Y/N) | Fallback Policy | Example Value | Notes |
|---------------|--------------|-----------|---------------|--------------|---------------|-----------------|---------------|-------|
| PatientFullName | Patient Full Name | Text | N | N | Y | Not provided | John A. Doe | Protected PHI |
| PatientFullSSN | Patient Full SSN | Text | N | N | Y | Not provided | ***-**-1234 | Mask before external use |
| PatientAddress | Patient Address | Text | N | (Check) | Y | Not provided | 123 Main St, City, ST | Plain text vs structured? |
| PreferredPhoneNumber | Preferred Phone Number | Text | N | (Check) | Y | Not provided | (555) 123-4567 | Format normalization needed? |
| DateEvaluated | Date Evaluated | DateTime | N | N | N | Not provided | 2025-11-06T15:20Z | Time zone conversion applied |
| MaritalStatus | Marital Status | Choice | Y | Y | N | Not provided | Married | /Value required |
| UsualLivingArrangements | Usual Living Arrangements | Choice | Y | Y | N | Not provided | Lives Alone | |
| LastAgencyProvidingCare | Last Agency Providing Care | Choice | Y | Y | N | Not provided | Home Health Agency | |
| TypeOfAgency | Type Of Agency | Choice | Y | Y | N | Not provided | Hospice | |
| PrimaryDiagnosis | Primary Diagnosis | Text | N | N | Y | Not provided | CHF | Clinical condition |
| SecondaryDiagnoses | Secondary Diagnoses | Multiline Text | N | N | Y | Not provided | Diabetes; COPD | Delimiter policy? |
| Vision | Vision | Choice | Y | Y | N | Not provided | Impaired | |
| Hearing | Hearing | Choice | Y | Y | N | Not provided | Normal | |
| ExpressiveCommunication | Expressive Communication | Choice | Y | Y | N | Not provided | Limited | |
| ReceptiveCommunication | Receptive Communication | Choice | Y | Y | N | Not provided | Good | |
| ADLBathingorShower | ADL Bathing or Shower | Choice | Y | Y | N | Not provided | Needs Assist | |
| ADLDressing | ADL Dressing | Choice | Y | Y | N | Not provided | Independent | |
| ADLUsingToilet | ADL Using Toilet | Choice | Y | Y | N | Not provided | Needs Assist | |
| ActivitiesOfDailyLiving | ADL Transfer | Choice | Y | Y | N | Not provided | Partial Assist | Transfer capability |
| ADLEating | ADL Eating | Choice | Y | Y | N | Not provided | Independent | |
| ADLWalking | ADL Walking | Choice | Y | Y | N | Not provided | Ambulates w/ Walker | Mobility aid notation |
| ContinenceBowel | Continence Bowel | Choice | Y | Y | N | Not provided | Incontinent | |
| Continence | Continence Bladder | Choice | Y | Y | N | Not provided | Continent | |
| Mobility | Mobility | Choice | Y | Y | N | Not provided | Limited | |
| AdaptiveTasks | Adaptive Tasks | Choice | Y | Y | N | Not provided | Needs Support | |
| BehaviorProblems | Behavior Problems | Choice | Y | Y | N | Not provided | None | |
| DisorientationMemoryImpairment | Disorientation Memory Impairment | Choice | Y | Y | N | Not provided | Mild | |
| DisturbanceOfMood | Disturbance Of Mood | Choice | Y | Y | N | Not provided | Stable | |
| CaregiverLimitations | Caregiver Limitations | Choice | Y | Y | N | Not provided | Limited Availability | |
| HBHCAdmissionDate | HBPC Admission Date | Date | N | (Check) | N | Not provided | 2025-11-05 | Verify /Value need |
| AdmissionType | Admission Type | Choice | Y | Y | N | Not provided | New | |
| LevelOfCare | Level Of Care | Choice | Y | Y | N | Not provided | High | |
| HBPCAdmittingMDTeam | HBPC Admitting MD or Team | Choice/Text | Y? | (Check) | N | Not provided | Dr. Smith / Team A | Choice vs Text validation |
| HBPCPrimaryNurse | HBPC Primary RN | Choice/Text | Y? | (Check) | N | Not provided | Nurse Jones | |
| EmergencyPlanPriorityLevel | Emergency Plan Priority Level | Choice | Y | Y | N | Not provided | Level 2 | |
| DoesTheVeteranUse | Does the Veteran Use | Choice | Y | Y | N | Not provided | Oxygen | Multi-select? |
| Created | Created Timestamp | DateTime | N | N | N | Not available | 2025-11-06T21:05Z | ConvertTimeZone used |
| Author/DisplayName | Submitted By | Person | N | N | Y | Unknown | Jane Smith | Person field expansion |

> Mark "Uses /Value?" accurately after verifying each field's JSON structure in a sample run output.

## Data Classification Summary
- PHI/PII fields: PatientFullName, PatientFullSSN, PatientAddress, PreferredPhoneNumber, any condition-related diagnoses.
- Non-PHI operational metadata: Created, Author/DisplayName, AdmissionType.

## Fallback Policy Standard
All user-facing fields should use `if(empty(...),'Not provided', ...)` unless a deliberate alternative (e.g., `Unknown` for identity fields) is approved.

## Review Checklist
- [ ] Each field internal name validated against SharePoint schema.
- [ ] Correct data type recorded.
- [ ] /Value usage confirmed for each choice field.
- [ ] PHI classification reviewed by compliance officer.
- [ ] Fallback policy alignment verified.

---
_Last updated: 2025-11-06 (initial scaffolding – update with authoritative values)_
