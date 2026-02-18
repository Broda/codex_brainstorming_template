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
6. Finalize and run audit.

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
- Risk template: `templates/risk_template.md`
- Review gate template: `templates/review_gate_template.md`

## Validation

Run:

```sh
./scripts/validate-governance
```

This checks link integrity, idea-state consistency, export references, and core artifact presence.

## Cross-Device Continuity

- Milestone updates auto-commit by default.
- Auto-commits auto-push to `origin/<current-branch>`.
- If remote push fails, local commits stay intact for retry from any location.
