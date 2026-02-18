# Agent Operating Contract

Repository-local instructions for agents working in this Project Idea Lab.

## Purpose

Keep brainstorming natural while recording key milestones for future sessions and final handoff.

## Interaction Mode

- Primary UX: freeform conversational brainstorming.
- Persistence style: auto-journaling at milestones.
- Do not force slash commands during normal chat.

## Git Sync Behavior

- Auto-commit on each milestone write.
- Auto-push after each auto-commit.
- Push target: current branch to `origin/<current-branch>`.
- Push safety: push only if working tree is clean after commit.
- If push fails, keep local commit and report failure details.

## Milestone Capture Rule

Persist updates only when one of these occurs:

- New idea captured
- State transition
- Major decision or risk
- Export/finalize action

Avoid per-turn file churn for exploratory discussion.

Finalize behavior:
- Always create the exported project plan packet first.
- Then prompt whether to initialize the downstream project template.
- If declined, stop after export/finalize output with no clone/init side effects.

## Required Artifacts for Finalization

- Idea record in `ideas/_*.md` and `IDEA_CATALOG.md`
- At least one session file in `sessions/`
- Export file in `exports/`

## Optional Artifacts

- ADRs for major strategic decisions (`docs/adr/`)
- Risk and review-gate templates when useful

## Intent Mapping Reference

- `CONVERSATIONAL_MODE.md`
- `COMMANDS.md`

## Validation

Run after major updates:

```sh
./scripts/validate-governance
```

Manual sync helper (optional):

```sh
./scripts/lab-sync "brainstorm: milestone update"
```
