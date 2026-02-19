# Project Idea Lab

Lightweight, conversational template for brainstorming project ideas and turning them into a final `PROJECT_PLAN_PACKET` for build handoff.

## How to Use This Naturally

Use normal freeform chat. Codex records only milestone events:

- new idea captured
- state transition (inbox/active/parked/killed/exported)
- major decision or risk
- export/finalize

No slash command syntax is required in normal use.

## Core Workflow

1. Brainstorm freely.
2. Capture idea into `ideas/_inbox.md`.
3. Move promising ideas to `ideas/_active.md` with a session file in `sessions/`.
4. Record decisions/risks only when useful.
5. Export a final packet in `exports/`.
6. Finalize and choose whether to initialize a project from the exported plan.
7. Run audit.

## Core Docs

- Agent contract: `AGENTS.md`
- Conversational mode: `CONVERSATIONAL_MODE.md`
- Backend command mapping: `COMMANDS.md`
- Quickstart: `QUICKSTART.md`
- File index: `FILE_MAP.md`
- Idea catalog: `IDEA_CATALOG.md`

## Optional Tools

- ADR template: `docs/adr/template.md`
- Decision template: `templates/decision_template.md`
- Research note template: `templates/note_template.md`
- Risk template: `templates/risk_template.md`
- Review gate template: `templates/review_gate_template.md`

## Research Notes

- Save gathered information into durable notes with:
  - `./scripts/lab-note.sh --topic "<topic>" --source "<context>" --summary "<bullet>"`
  - or `./scripts/lab-note --topic "<topic>" ...`
- Notes are written to `notes/` and indexed in `NOTES_CATALOG.md`.

## Validation

Run:

```sh
./scripts/validate-governance
```

This checks link integrity, idea-state consistency, export references, and core artifact presence.

## Cross-Device Continuity

- Milestone updates auto-commit by default.
- Auto-commits auto-push to `origin/<current-branch>`.
- Focus Mode is on by default: routine recording/sync chatter stays hidden during brainstorming.
- If remote push fails, local commits stay intact for manual retry without interrupting flow.

## Optional Project Initialization Handoff

- Run: `./scripts/handoff-init.sh --idea-id <idea-id>` (or `./scripts/handoff-init --idea-id <idea-id>`).
- The script always creates `exports/YYYY-MM-DD_PROJECT_PLAN_PACKET_<idea-id>.md`.
- It then asks whether to continue with template initialization.
- If declined, flow ends at project plan creation.
- If accepted, it clones `git@github.com:Broda/codex_template.git`, removes inherited `origin`, and prompts you to set a new private `origin`.
- It then runs guided initialization.
