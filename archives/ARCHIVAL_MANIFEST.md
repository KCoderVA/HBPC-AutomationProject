# Archival Manifest (2025-11-07)

## Overview
Non-destructive consolidation performed. Authoritative originals and enriched variants retained in `src/flows/HBPC_AdmitsDischarges/stages/`. Placeholder / abbreviated or partial duplicates moved here under `archives/` preserving full relative paths for forensic retrieval.

## Policy
- No file deletions; only moves.
- Originals identified by suffixes: `originalVerbose`, `originalSource`.
- Enriched migrated artifacts suffixed: `_full`, `_narrative`.
- Hash integrity file: `metadata/hashes.json`.

## Relocated Placeholder Examples (Test5 Stage)
- compose_outputs/outputs.html (abbreviated version) -> archived
- raw_parameters/raw_parameters.html (abbreviated version) -> archived
- peek_raw_code/peek_raw_code.json (partial placeholder) -> archived

## Stages Without Placeholder Relocation
- baseline_lastSuccess (originals + placeholders still pending enrichment; none archived today)
- reportedFailure (placeholders remain un-enriched; left in place)
- test4_partialSuccess (already fully enriched; no duplicates)

## Future Actions
1. If baseline/report failure placeholders are to be enriched, migrate originals in parallel and archive placeholders afterward.
2. Add automated script to diff `metadata/hashes.json` against regenerated hash set post-changes.
3. Integrate archival logging into `runInfo.json` for baseline and reportedFailure once placeholders migrate.

## Retrieval Procedure
Any archived file retains its original relative path under `archives/`. Example:
```
archives/src/flows/HBPC_AdmitsDischarges/stages/test5_partialSuccess/peek_raw_code/peek_raw_code.json
```

## Integrity
Refer to `metadata/hashes.json` for current SHA256 fingerprints.

---
Generated automatically on 2025-11-07.
