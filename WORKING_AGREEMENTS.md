# Working Agreements

Operational defaults for solo-first teams that may scale to small collaboration groups.

## Cadence

- Default review cadence: weekly.
- Optional higher cadence: biweekly deep review + weekly light check.
- Parked ideas review cadence: every 30 days.

## Definition of Active Idea

An idea is `active` only when all are true:
- It has an owner.
- It has at least one linked session in `sessions/`.
- It has a next action and due date in `IDEA_CATALOG.md`.
- It is being advanced toward review or export.

## WIP Limit

- Default WIP cap: 3 active ideas.
- If WIP cap is exceeded, no new activation unless one idea is exported, parked, or killed.

## ADR Ownership and Review

- ADR author owns initial draft and cross-link updates.
- Strategic ADRs (Level 3) should be reviewed by at least one additional reviewer when team size > 1.
- Superseding ADRs must update both old and new ADR status fields.

## Escalation Rules

Escalate in review sessions when:
- unresolved high-impact risk has no owner,
- export is requested with missing gate evidence,
- strategic decision is made without ADR where required.

## Update Rule

Revisit working agreements monthly or when team size/process changes materially.
