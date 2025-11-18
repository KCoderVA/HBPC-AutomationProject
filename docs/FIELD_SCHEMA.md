# HBPC Admission Field Schema

Authoritative metadata for each SharePoint field consumed by the HBPC Admission HTML Compose action. This table evolves as schema is verified. Fields are grouped by functional domain. Use this to audit PHI handling, ensure correct dereferencing (`/Value`), and standardize fallbacks.

## Legend
| Column | Meaning |
|--------|---------|
| Choice? | SharePoint Choice (single) or Multi-select requiring `/Value` or array handling |
| Uses /Value? | Should path end in `/Value` when retrieving human-readable selection |
| PHI/PII | Contains personally identifiable or protected health information |
| Fallback Policy | Expected fallback text when empty |

## Patient / Identity
| Internal Name | Display Label | Data Type | Choice? | Uses /Value? | PHI/PII | Fallback Policy | Example Value | Notes |
|---------------|--------------|----------|---------|--------------|---------|-----------------|---------------|-------|
| PatientFullName | Patient Full Name | Text | N | N | Y | Not provided | John A. Doe | Mask in external contexts |
| PatientFullSSN | Patient Full SSN | Text | N | N | Y | Not provided | ***-**-1234 | Stored masked or partially masked |
| PreferredPhoneNumber | Preferred Phone Number | Text | N | N | Y | Not provided | (555) 123-4567 | Normalize format (E.164) pending |
| PatientAddress | Patient Address | Text | N | N | Y | Not provided | 123 Main St, City, ST | Verify address components |
| Created | Created Timestamp | DateTime | N | N | N | Not available | 2025-11-06T21:05Z | Converted to CST in output |
| Author/DisplayName | Submitted By | Person | N | N | Y | Unknown | Jane Smith | Expand for dept if needed |

## Social / Living
| Internal Name | Display Label | Data Type | Choice? | Uses /Value? | PHI/PII | Fallback Policy | Example Value | Notes |
|---------------|--------------|----------|---------|--------------|---------|-----------------|---------------|-------|
| MaritalStatus | Marital Status | Choice | Y | Y | N | Not provided | Married | |
| UsualLivingArrangements | Usual Living Arrangements | Choice | Y | Y | N | Not provided | Lives Alone | |
| LastAgencyProvidingCare | Last Agency Providing Care | Choice | Y | Y | N | Not provided | Home Health Agency | |
| TypeOfAgency | Type Of Agency | Choice | Y | Y | N | Not provided | Hospice | |

## Medical
| Internal Name | Display Label | Data Type | Choice? | Uses /Value? | PHI/PII | Fallback Policy | Example Value | Notes |
|---------------|--------------|----------|---------|--------------|---------|-----------------|---------------|-------|
| PrimaryDiagnosis | Primary Diagnosis | Text | N | N | Y | Not provided | CHF | Clinical condition |
| SecondaryDiagnoses | Secondary Diagnoses | Multiline Text | N | N | Y | Not provided | Diabetes; COPD | Consider delimiter standard |
| DateEvaluated | Date Evaluated | DateTime | N | N | N | Not provided | 2025-11-06T15:20Z | Confirm timezone source |

## Functional Assessment & ADL
| Internal Name | Display Label | Data Type | Choice? | Uses /Value? | PHI/PII | Fallback Policy | Example Value | Notes |
|---------------|--------------|----------|---------|--------------|---------|-----------------|---------------|-------|
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

## Continence / Mobility / Behavior
| Internal Name | Display Label | Data Type | Choice? | Uses /Value? | PHI/PII | Fallback Policy | Example Value | Notes |
|---------------|--------------|----------|---------|--------------|---------|-----------------|---------------|-------|
| ContinenceBowel | Continence Bowel | Choice | Y | Y | N | Not provided | Incontinent | |
| Continence | Continence Bladder | Choice | Y | Y | N | Not provided | Continent | |
| Mobility | Mobility | Choice | Y | Y | N | Not provided | Limited | |
| AdaptiveTasks | Adaptive Tasks | Choice | Y | Y | N | Not provided | Needs Support | |
| BehaviorProblems | Behavior Problems | Choice | Y | Y | N | Not provided | None | |
| DisorientationMemoryImpairment | Disorientation Memory Impairment | Choice | Y | Y | N | Not provided | Mild | |
| DisturbanceOfMood | Disturbance Of Mood | Choice | Y | Y | N | Not provided | Stable | |
| CaregiverLimitations | Caregiver Limitations | Choice | Y | Y | N | Not provided | Limited Availability | |

## Admission Details
| Internal Name | Display Label | Data Type | Choice? | Uses /Value? | PHI/PII | Fallback Policy | Example Value | Notes |
|---------------|--------------|----------|---------|--------------|---------|-----------------|---------------|-------|
| HBHCAdmissionDate | HBPC Admission Date | Date | N | N | N | Not provided | 2025-11-05 | Verify if date formatting applied |
| AdmissionType | Admission Type | Choice | Y | Y | N | Not provided | New | |
| LevelOfCare | Level Of Care | Choice | Y | Y | N | Not provided | High | |
| HBPCAdmittingMDTeam | HBPC Admitting MD or Team | Choice/Text | ? | (Check) | N | Not provided | Dr. Smith / Team A | Verify field type (multi-choice?) |
| HBPCPrimaryNurse | HBPC Primary RN | Choice/Text | ? | (Check) | N | Not provided | Nurse Jones | |
| EmergencyPlanPriorityLevel | Emergency Plan Priority Level | Choice | Y | Y | N | Not provided | Level 2 | |
| DoesTheVeteranUse | Does the Veteran Use | Choice (Multi?) | Y | Y | N | Not provided | Oxygen | Multi-select confirm |

## Classification Summary
- PHI/PII: Patient identity, address, phone, diagnoses, submitter identity.
- Operational Metadata: Created timestamp, non-clinical categorical selections.

## Fallback Standard
Use `Not provided` except:
- Identity fields lacking submission: consider `Unknown` (policy decision pending).
- System timestamps: `Not available` when absent.

## Verification Tasks (To Complete)
- [ ] Confirm `/Value` necessity for each field via sample run JSON.
- [ ] Identify any multi-select arrays requiring join logic.
- [ ] Validate PHI list with compliance officer.
- [ ] Normalize MD/RN team fields final data type.

## Roadmap
1. Export fresh sample with all fields populated & one with sparse/nulls.
2. Auto-generate this table from flow run JSON (future script in `scripts/`).
3. Add CI check asserting every referenced field appears here.

---
_Last updated: 2025-11-07 (expanded grouping & roadmap)_

<!-- SCHEMA-SUMMARY:START -->
| Internal | Label | Section | Category | Sensitivity | Type |
|---------|-------|---------|----------|------------|------|
| AdmissionDate | Admission Date | Identity | Encounter | Moderate | DateTime |
| CarePlanSummary | Care Plan Summary | Clinical | Plan | Moderate | Text |
| Hearing | Hearing | Assessment | Functional | Low | Choice |
| MobilityLevel | Mobility Level | Assessment | Functional | Low | Choice |
| PatientFullName | Patient Full Name | Identity | DirectIdentifier | High | Text |
| PatientFullSSN | Patient Full SSN | Identity | DirectIdentifier | High | Text |
| PrimaryCaregiverRelationship | Primary Caregiver Relationship | Social | CareSupport | Low | Choice |
| PrimaryDiagnosis | Primary Diagnosis | Clinical | Condition | Moderate | Text |
| PrimaryProviderName | Primary Provider Name | CareTeam | Staff | Moderate | Text |
| PreferredLanguage | Preferred Language | Identity | Demographic | Low | Choice |
| Vision | Vision | Assessment | Functional | Low | Choice |
<!-- SCHEMA-SUMMARY:END -->
