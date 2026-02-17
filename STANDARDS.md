# Standards

Balanced governance standards for IDs, naming, transitions, and artifact hygiene.

## ID Conventions

- Idea ID: `idea-[a-z0-9-]+`
- Decision ID: `decision-[0-9]{3}`
- Risk ID: `risk-[0-9]{3}`
- ADR ID: `ADR-[0-9]{4}`

## Naming Conventions

- Project codenames: kebab case
- Session files: `YYYY-MM-DD_session_<topic>.md`
- Export files: `YYYY-MM-DD_PROJECT_PLAN_PACKET_<idea-id>.md`
- ADR files: `docs/adr/ADR-XXXX-<kebab-case-title>.md`

## Mandatory Lifecycle Transition Block

Use this block for every move between `ideas/_inbox.md`, `ideas/_active.md`, `ideas/_parked.md`, and `ideas/_killed.md`.

```md
### Transition Record
- Date: YYYY-MM-DD
- Owner:
- Idea ID:
- From:
- To:
- Reason:
- Evidence:
- Next Review: YYYY-MM-DD (required when `To: parked`)
```

## Catalog Synchronization Rule

Every lifecycle transition must update `IDEA_CATALOG.md` in the same change set.

Required catalog updates:
- Status
- Current Gate
- Next Action Owner
- Next Action Due
- Last Reviewed
- Linked sessions/ADRs/exports when applicable

## Documentation Minimums

Every substantive change should include:
- Date
- Owner
- Status
- Linked artifacts
- Next action or closure condition

## Audit Rule

Run `scripts/validate-governance.ps1` (or `/lab audit`) after governance-impacting changes.
