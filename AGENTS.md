# Agent Operating Contract

Repository-local instructions for agents working in this Project Idea Lab.

## Purpose

Keep brainstorming natural while recording key milestones for future sessions and final handoff.

## Interaction Mode

- Primary UX: freeform conversational brainstorming.
- Persistence style: auto-journaling at milestones.
- Do not force slash commands during normal chat.
- Focus Mode: on by default.

## Git Sync Behavior

- Auto-commit on each milestone write.
- Auto-push after each auto-commit.
- Push target: current branch to `origin/<current-branch>`.
- Push safety: push only if working tree is clean after commit.
- Autosync runs in quiet mode by default (hide inconsequential status output).
- Push failures are silent and non-blocking in default brainstorming flow.
- If push fails, keep local commit for later manual push.

Focus Mode visibility rules:
- Show: direct user responses, required user questions/prompts, consequential failures.
- Hide: routine recording/commit/push success chatter and other inconsequential background status.

## Milestone Capture Rule

Persist updates only when one of these occurs:

- New idea captured
- State transition
- Major decision or risk
- Research note captured
- Export/finalize action

Avoid per-turn file churn for exploratory discussion.

Finalize behavior:
- Always create the exported project plan packet first.
- Then prompt whether to initialize the downstream project template.
- If declined, stop after export/finalize output with no clone/init side effects.

Research note capture behavior:
- Support note-save intents such as:
  - "save that info in notes"
  - "save a note on <topic>"
  - "save that research"
- Resolve source context from recent relevant assistant research.
- If multiple plausible contexts exist, ask one quick clarifier with top candidates.
- If no plausible context exists, ask user to restate target topic/cue.
- Persist notes to `notes/` and register in `NOTES_CATALOG.md`.

## Topic-Shift Continuity Nudges

To reduce idea loss during exploratory branching:

- Maintain session-scoped nudge state:
  - `last_milestone_ts`
  - `last_nudge_ts`
  - `current_thread_signature` (lightweight keyword/topic summary)
- Use heuristic topic-shift detection (no ML requirement):
  - Explicit shift phrases (e.g., "switching", "new topic", "another idea", "unrelated")
  - Abrupt keyword/domain drift from recent turns
  - Decision/risk intent markers (e.g., "we should", "let's do", "tradeoff", "risk")
- Only auto-nudge when confidence is `medium` or `high`.
- Cooldown: at most one auto-nudge every 10 minutes.
- Nudges are advisory, not mandatory.

When a nudge triggers, ask:
- "Before we switch, save the previous thread?"
- Quick actions:
  - `capture idea`
  - `record decision`
  - `log risk`
  - `save path note`
  - `skip`

Session boundary checkpoint:
- On a new session start in the same repo, ask once:
  - "Any key prior thread to persist before we continue?"
- Offer the same quick actions.

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
