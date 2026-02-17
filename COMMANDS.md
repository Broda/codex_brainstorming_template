# Commands

Governance-aware command contract for the Project Idea Lab.

## Command Conventions

- Prefix: `/lab`
- Project codename format: kebab case (`idea-codename`)
- Idea ID format: `idea-<kebab-case>`
- Decision ID format: `decision-<nnn>`
- Risk ID format: `risk-<nnn>`
- ADR file format: `ADR-XXXX-<kebab-case-title>.md`
- Dates: `YYYY-MM-DD`
- Source of truth for ADR template: `docs/adr/template.md`

## Global Rules (Apply to Every Command)

- Never delete existing content.
- Always timestamp changes.
- Always update affected indexes (`IDEA_CATALOG.md`, `FILE_MAP.md`, and `GOVERNANCE_INDEX.md` when governance artifacts change).
- Preserve historical records; use status transitions and supersedence, not destructive edits.
- For lifecycle moves, include transition block from `STANDARDS.md`.

## Commands

### `/lab capture <idea-id>`

Effect:
- Appends new idea record to `ideas/_inbox.md` from `templates/idea_template.md`.
- Adds row to `IDEA_CATALOG.md` with status `inbox`.
- Updates `FILE_MAP.md` last-modified entries.

### `/lab activate <idea-id>`

Effect:
- Moves idea state from inbox to active (non-destructive transition record required).
- Creates or updates a session file in `sessions/`.
- Updates catalog and file map.

### `/lab decide <decision-slug>`

Effect:
- Determines decision level using `DECISION_POLICY.md`.
- For Level 3: must create `docs/adr/ADR-XXXX-<decision-slug>.md` from `docs/adr/template.md`.
- For Level 1/2: may remain session-only using `templates/decision_template.md`, unless marked durable.
- Updates `IDEA_CATALOG.md` decision references.

### `/lab risk <idea-id>`

Effect:
- Records risk entry in current session using `templates/risk_template.md`.
- Ensures mitigation, contingency, and owner fields are populated.

### `/lab review <idea-id>`

Effect:
- Runs checklist from `REVIEW_WORKFLOW.md` and `QUALITY_BAR.md`.
- Records gate result (`pass`, `conditional-pass`, `fail`) in session file using `templates/review_gate_template.md`.
- Updates catalog notes and operational fields.

### `/lab export <idea-id>`

Effect:
- Generates `exports/YYYY-MM-DD_PROJECT_PLAN_PACKET_<idea-id>.md` using `templates/project_plan_packet_template.md`.
- Requires quality gate outcome from latest review.
- Adds export path to `IDEA_CATALOG.md`.

### `/lab finalize <idea-id>`

Effect:
- Marks idea status as `exported`.
- Preconditions: latest review gate must be `pass` or `conditional-pass` with owned conditions.
- Confirms export immutability and records any follow-up ownership.
- Updates all affected indexes.

### `/lab park <idea-id>`

Effect:
- Transitions idea to `ideas/_parked.md` with re-entry criteria and next review date.
- Updates catalog status and references.

### `/lab kill <idea-id>`

Effect:
- Transitions idea to `ideas/_killed.md` with evidence and anti-goals.
- Updates catalog status and references.

### `/lab supersede-adr <old-adr> <new-adr>`

Effect:
- Sets old ADR status to `Superseded` and adds `Superseded by` link.
- Sets new ADR `Supersedes` link.
- Updates decision references in `IDEA_CATALOG.md`.

### `/lab audit`

Effect:
- Runs governance integrity checker: `scripts/validate-governance.ps1`.
- Verifies ADR links, catalog/status mapping, export references, and required governance artifacts.
- Flags stale or missing file-map coverage as warnings.

## Artifact Update Matrix

| Command | Required File Updates |
|---|---|
| capture | `ideas/_inbox.md`, `IDEA_CATALOG.md`, `FILE_MAP.md` |
| activate | `ideas/_active.md`, `sessions/*`, `IDEA_CATALOG.md`, `FILE_MAP.md` |
| decide | `docs/adr/*` or `sessions/*`, `IDEA_CATALOG.md`, `FILE_MAP.md` |
| review | `sessions/*`, `IDEA_CATALOG.md`, `FILE_MAP.md` |
| export | `exports/*`, `IDEA_CATALOG.md`, `FILE_MAP.md` |
| finalize | state file updates, `IDEA_CATALOG.md`, `FILE_MAP.md` |
| audit | `scripts/validate-governance.ps1` (read-only), optional remediation updates |
