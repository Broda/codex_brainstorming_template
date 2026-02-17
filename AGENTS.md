# Agent Operating Contract

Repository-local instructions for agents working in this Project Idea Lab.

## Purpose

Keep brainstorming natural while recording key milestones for future sessions and final handoff.

## Interaction Mode

- Primary UX: freeform conversational brainstorming.
- Persistence style: auto-journaling at milestones.
- Do not force slash commands during normal chat.

## Milestone Capture Rule

Persist updates only when one of these occurs:

- New idea captured
- State transition
- Major decision or risk
- Export/finalize action

Avoid per-turn file churn for exploratory discussion.

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

```powershell
powershell -ExecutionPolicy Bypass -File scripts/validate-governance.ps1
```
