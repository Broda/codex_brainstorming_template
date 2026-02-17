# Commands

Backend contract for conversational operations in the Project Idea Lab.

## Usage Style

- Primary UX: conversational intent (plain language).
- `/lab` command syntax remains optional and supported.

## Conventions

- Idea ID format: `idea-<kebab-case>`
- Decision ID format: `decision-<nnn>`
- Risk ID format: `risk-<nnn>`
- ADR ID format: `ADR-XXXX`
- Dates: `YYYY-MM-DD`

## Conversational Intent Mapping

| Conversational phrase | Backend intent |
|---|---|
| "capture this idea" | `/lab capture <idea-id>` |
| "make this active" | `/lab activate <idea-id>` |
| "decision: ... because ..." | `/lab decide <decision-slug>` |
| "risk: ..." | `/lab risk <idea-id>` |
| "review this idea" | `/lab review <idea-id>` |
| "finalize/export plan" | `/lab export <idea-id>` + `/lab finalize <idea-id>` |
| "park this" | `/lab park <idea-id>` |
| "kill this" | `/lab kill <idea-id>` |
| "run audit" | `/lab audit` |

## Commands (Backend Contract)

### `/lab capture <idea-id>`
- Add/update idea in `ideas/_inbox.md` using `templates/idea_template.md`.
- Add/update row in `IDEA_CATALOG.md`.
- Update `FILE_MAP.md` when file inventory changes.

### `/lab activate <idea-id>`
- Move/update idea in `ideas/_active.md`.
- Create/update session file in `sessions/`.
- Update `IDEA_CATALOG.md`.

### `/lab decide <decision-slug>`
- Record decision in session using `templates/decision_template.md`.
- For major strategic changes, create ADR from `docs/adr/template.md`.
- Update `IDEA_CATALOG.md` references.

### `/lab risk <idea-id>`
- Record risk in session using `templates/risk_template.md`.

### `/lab review <idea-id>`
- Record review notes and optional gate using `templates/review_gate_template.md`.
- Update `IDEA_CATALOG.md`.

### `/lab export <idea-id>`
- Create `exports/YYYY-MM-DD_PROJECT_PLAN_PACKET_<idea-id>.md` using `templates/project_plan_packet_template.md`.
- Update export link in `IDEA_CATALOG.md`.

### `/lab finalize <idea-id>`
- Mark idea status `exported`.
- Ensure export path is present in `IDEA_CATALOG.md`.

### `/lab park <idea-id>`
- Move/update idea in `ideas/_parked.md`.
- Update `IDEA_CATALOG.md`.

### `/lab kill <idea-id>`
- Move/update idea in `ideas/_killed.md`.
- Update `IDEA_CATALOG.md`.

### `/lab audit`
- Run `scripts/validate-governance.ps1`.

## Minimum Required Artifacts per Finalized Idea

- Idea record (`ideas/_*.md` + `IDEA_CATALOG.md`)
- At least one related session (`sessions/*`)
- Final export packet (`exports/*`)
