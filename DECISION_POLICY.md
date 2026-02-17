# Decision Policy

## What This Policy Enforces

- Decision classification by impact level.
- Mandatory ADRs for strategic and architectural decisions.
- Traceability from idea records and exports to decisions.
- Supersedence handling when decisions change.

## Why This Exists

Idea labs degrade when decisions are implicit or lost in notes. This policy ensures critical choices are durable, reviewable, and linked to outcomes.

## Decision Levels

- Level 1 (Local): Small execution choices limited to one session. Record in session notes.
- Level 2 (Project): Choices that change scope, milestones, risk posture, or export assumptions. Record in decision log and reference ADR when durable.
- Level 3 (Strategic/Architectural): Changes to governance model, decision standards, data model, template contract, or handoff strategy. ADR required.

## ADR Requirements

Create an ADR when any of the following applies:

- Decision affects multiple ideas or the whole repository workflow.
- Decision changes command behavior or quality gates.
- Decision introduces or removes required artifacts.
- Decision has non-trivial long-term consequences or tradeoffs.

## ADR Naming and Numbering

- File format: `docs/adr/ADR-XXXX-<kebab-case-title>.md`
- Numbering: zero-padded ascending sequence (`ADR-0001`, `ADR-0002`, ...)
- Status values: `Proposed`, `Accepted`, `Superseded`, `Deprecated`

## Supersedence Rules

- New ADR replacing old guidance must include `Supersedes: ADR-XXXX`.
- Old ADR must be updated with `Superseded by: ADR-YYYY` and status `Superseded`.
- `IDEA_CATALOG.md` and impacted exports must reference the newer ADR.

## Compliance Steps (Example)

1. Scope change affects all future exports.
2. Create `docs/adr/ADR-0002-export-gate-adjustment.md` from template.
3. Update `COMMANDS.md` and `QUALITY_BAR.md` if behavior changes.
4. Add ADR link in `IDEA_CATALOG.md` and related session record.

## Artifact Locations

- ADR files: `docs/adr/`
- Session-level decision notes: `sessions/`
- Governance command impacts: `COMMANDS.md`
- Cross-reference index: `IDEA_CATALOG.md`
