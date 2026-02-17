# Conversational Mode

Lightweight mode for chat-first brainstorming with milestone-based recording.

## Defaults

- Auto-journaling: on
- Write cadence: milestone-based
- Slash commands: optional

## Milestones That Trigger Recording

- new idea captured
- state transition
- major decision or risk
- export/finalize

## Intent Map

| Natural phrase | Action | Files touched |
|---|---|---|
| "let's brainstorm `<idea-id>`" | open/continue context | `sessions/*` (as needed) |
| "capture this idea" | add idea intake | `ideas/_inbox.md`, `IDEA_CATALOG.md` |
| "make this active" | move to active | `ideas/_active.md`, `sessions/*`, `IDEA_CATALOG.md` |
| "decision: ... because ..." | record decision | `sessions/*` and optionally `docs/adr/*` |
| "risk: ..." | record risk | `sessions/*` |
| "review this idea" | record review/gate | `sessions/*`, `IDEA_CATALOG.md` |
| "finalize/export plan" | create export + mark exported | `exports/*`, state files, `IDEA_CATALOG.md` |
| "run audit" | validate integrity | `scripts/validate-governance.ps1` |

## Notes

- Freeform conversation is valid; no write occurs until milestones happen.
- For small ideas, keep artifacts minimal: idea + session + export.
