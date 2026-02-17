# Security Policy

## What This Policy Enforces

- Safe handling of sensitive brainstorming and planning content.
- Minimal inclusion of confidential details in general idea records.
- Clear redaction and reference practices.

## Why This Exists

Idea repositories can include strategic, customer, or operational details that should not be broadly exposed.

## Data Sensitivity Levels

- `Public`: Safe for broad sharing.
- `Internal`: Team-only planning content.
- `Restricted`: Sensitive business or personal data; avoid storing directly when possible.

## Rules

- Do not store secrets, API keys, credentials, or private tokens.
- Do not store PII unless strictly needed; prefer anonymized summaries.
- For restricted details, store only a short reference note and location pointer.
- Mark records with sensitivity when ambiguity exists.

## How to Comply (Example)

- In an idea entry, write: `Sensitivity: Internal`.
- Replace specific customer identifiers with role labels.
- Document sensitive source references without copying raw secret data.

## Artifact Locations

- Sensitivity annotations: idea/session/export records
- Policy updates: `SECURITY_POLICY.md`
- Governance review checks: `REVIEW_WORKFLOW.md`, `QUALITY_BAR.md`
