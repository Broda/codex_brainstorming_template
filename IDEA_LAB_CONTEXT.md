# Idea Lab Context

## Purpose

Maintain a disciplined system for idea lifecycle management from intake to handoff-ready project plan.

## Governance Anchors

- `GOVERNANCE_INDEX.md`
- `DECISION_POLICY.md`
- `REVIEW_WORKFLOW.md`
- `QUALITY_BAR.md`

## Update Rules

1. Every file update must include:
- `Date: YYYY-MM-DD`
- `Owner:`
- `Change Summary:`

2. Idea lifecycle transitions are mandatory:
- `inbox -> active`
- `active -> parked`
- `active -> killed`
- `active -> export`

3. Transition records must include rationale:
- Why moved
- Trigger condition
- Next expected review date (for parked ideas)

4. Decision logging rules:
- One decision per entry
- Include context, options considered, chosen option, rationale, and consequences
- Link related idea ID and session file
- Use ADRs for Level 3 decisions per `DECISION_POLICY.md`

5. Risk logging rules:
- One risk per entry
- Include likelihood, impact, detection signal, mitigation, contingency, owner
- Reassess risk status at each milestone review

6. Session rules:
- One markdown file per working session in `sessions/`
- Filename format: `YYYY-MM-DD_session_<topic>.md`
- Must reference touched idea IDs and review outcomes

7. Export rules:
- Finalized project plan packet goes in `exports/`
- Filename format: `YYYY-MM-DD_PROJECT_PLAN_PACKET_<idea-id>.md`
- Export is read-only after handoff; updates require a new versioned export

8. Archival rules:
- Parked ideas require re-entry criteria
- Killed ideas require explicit kill reason and anti-goals

## Operating Assumptions

- This repo is for planning, not implementation code.
- Build execution happens in a separate build-template repository.
