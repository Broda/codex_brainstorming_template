# Conversational Mode

Lightweight mode for chat-first brainstorming with milestone-based recording.

## Defaults

- Auto-journaling: on
- Write cadence: milestone-based
- Auto-commit: on
- Auto-push: on
- Push policy: clean tree only
- Slash commands: optional
- Topic-shift continuity nudges: on
- Nudge cooldown: 10 minutes

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
| "save path note" | append exploration note to current session file | `sessions/*` |
| "review this idea" | record review/gate | `sessions/*`, `IDEA_CATALOG.md` |
| "finalize/export plan" | create export + mark exported, then optionally initialize template project | `exports/*`, state files, `IDEA_CATALOG.md`, cloned template repo |
| "run audit" | validate integrity | `scripts/validate-governance` |

## Notes

- Freeform conversation is valid; no write occurs until milestones happen.
- If a likely topic shift is detected, prompt once (respecting 10-minute cooldown): "Before we switch, save the previous thread?"
- Topic-shift quick actions: `capture idea`, `record decision`, `log risk`, `save path note`, `skip`.
- For small ideas, keep artifacts minimal: idea + session + export.
- No extra push phrase is required; milestone commits are auto-pushed by default.
- If push fails, local commits are preserved and surfaced for manual retry.
