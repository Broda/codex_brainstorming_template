# Agent Operating Contract

Repository-local instructions for agents working in this Project Idea Lab.

## Purpose

Use conversational brainstorming while preserving governed, traceable planning artifacts.

## Interaction Mode

- Primary UX: conversational auto-journaling.
- Write cadence: milestone-based.
- Slash commands are optional; plain-language intent is preferred.

## Milestone-Based Persistence

Persist only when one of these occurs:

- New idea captured
- Lifecycle state transition
- Decision or risk recorded
- Review gate set
- Export/finalize action

Do not create noisy per-turn file edits during pure brainstorming.

## Intent Mapping

- \"capture this idea\" -> update `ideas/_inbox.md` + `IDEA_CATALOG.md`
- \"make this active\" -> transition to `ideas/_active.md` + session link
- \"decision: ... because ...\" -> decision record; ADR if Level 3
- \"risk: ...\" -> risk entry in session
- \"review this idea\" -> review gate using `templates/review_gate_template.md`
- \"finalize/export plan\" -> create export + mark exported
- \"run audit\" -> execute `scripts/validate-governance.ps1`

Reference mapping details:
- `CONVERSATIONAL_MODE.md`
- `COMMANDS.md`

## Governance Requirements

- Never delete historical records.
- Always timestamp substantive updates (`YYYY-MM-DD`).
- Always update affected indexes:
  - `IDEA_CATALOG.md`
  - `FILE_MAP.md`
  - `GOVERNANCE_INDEX.md` (when governance artifacts change)
- Use transition block format from `STANDARDS.md` for lifecycle moves.

## Decision Policy

- Use session decisions for local/project decisions.
- Create ADRs for Level 3 strategic/architectural decisions.
- ADR canonical template: `docs/adr/template.md`

## Finalization Rules

- Export packet path:
  - `exports/YYYY-MM-DD_PROJECT_PLAN_PACKET_<idea-id>.md`
- Finalize only when latest gate is:
  - `pass`, or
  - `conditional-pass` with explicit owner/due conditions

## Validation

Run audit after governance-impacting changes:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/validate-governance.ps1
```

## Source-of-Truth Docs

- `README.md`
- `GOVERNANCE_INDEX.md`
- `CONVERSATIONAL_MODE.md`
- `COMMANDS.md`
- `STANDARDS.md`
