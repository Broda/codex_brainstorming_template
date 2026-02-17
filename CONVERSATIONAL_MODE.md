# Conversational Mode

Slash-command-free operating mode for chat-first brainstorming with structured persistence.

## Defaults

- Mode: `auto-journaling`
- Write cadence: `milestone-based`
- Goal: capture ideas, pathways, and decisions in normal conversation without explicit `/lab` command syntax.

## How It Works

Codex interprets plain-language intent and maps it to the existing governance workflow.

## Milestone Persistence Rule

Persist updates only when one of these occurs:

- New idea captured
- Lifecycle state transition
- Decision or risk recorded
- Review gate set
- Export/finalize action

Brainstorm-only conversation should not create noisy file churn until a milestone event occurs.

## Conversational Trigger Phrases

Typical examples (not exhaustive):

- "let's brainstorm `<idea-id>`"
- "capture this idea"
- "make this active"
- "decision: ... because ..."
- "risk: ..."
- "park this"
- "kill this"
- "review this idea"
- "finalize/export plan"
- "run audit"

## Intent Map

| Plain-language intent pattern | Primary action | Files touched | Template/artifact |
|---|---|---|---|
| brainstorm `<idea-id>` | open/continue working context | `sessions/*` (as needed) | session record |
| capture this idea | create/update idea intake | `ideas/_inbox.md`, `IDEA_CATALOG.md`, `FILE_MAP.md` | `templates/idea_template.md` |
| make this active | state transition to active | `ideas/_active.md`, `sessions/*`, `IDEA_CATALOG.md`, `FILE_MAP.md` | transition block from `STANDARDS.md` |
| decision: ... because ... | record decision; create ADR if L3 | `sessions/*` and optionally `docs/adr/*`, plus catalog/file map | `templates/decision_template.md`, `docs/adr/template.md` |
| risk: ... | record risk | `sessions/*`, `IDEA_CATALOG.md`, `FILE_MAP.md` | `templates/risk_template.md` |
| review this idea | set review gate | `sessions/*`, `IDEA_CATALOG.md`, `FILE_MAP.md` | `templates/review_gate_template.md` |
| finalize/export plan | create export + mark exported | `exports/*`, state files, `IDEA_CATALOG.md`, `FILE_MAP.md` | `templates/project_plan_packet_template.md` |
| run audit | validate governance integrity | none (read-only check) | `scripts/validate-governance.ps1` |

## `/lab` Compatibility

- `/lab` command syntax remains supported as backend contract.
- Conversational intent is the primary UX; slash commands are optional.

## Validation Scenarios

1. Brainstorm-only session creates no new records until a milestone.
2. "capture this idea" updates inbox + catalog + file map.
3. "decision: ..." records decision and creates ADR when Level 3.
4. "finalize/export plan" creates export artifact and exported state updates.
5. "run audit" reports zero blocking failures at lifecycle completion.

## Assumptions

- ChatGPT-style conversational planning is preferred.
- Persistence should happen at milestone boundaries, not every turn.
- Existing governance architecture remains unchanged.
