# Quality Bar

## What This Policy Enforces

Minimum criteria for any plan to be considered export-ready.

## Why This Exists

Exports are consumed by build repositories. Missing clarity or unresolved risk creates execution churn.

## Export Acceptance Criteria

1. MVP Clarity
- Problem, user, and value hypothesis are explicit.
- In-scope and out-of-scope boundaries are clear.

2. Decision Coverage
- Key strategic decisions are recorded.
- ADR links are present for Level 3 decisions.

3. Risk Handling
- Top risks identified and prioritized.
- Mitigations and contingencies are concrete.
- Owners are assigned to open high-impact risks.

4. Delivery Readiness
- Milestones and exit criteria are defined.
- Dependencies and assumptions are stated.
- Open questions are resolved or assigned with dates.

5. Traceability
- Idea record, sessions, ADRs, and export are cross-linked.

## Quality Gate Outcomes

- `pass`: export allowed
- `conditional-pass`: export allowed with explicitly tracked follow-ups
- `fail`: return to active review

## Gate Evidence Requirements

Review outputs must follow `templates/review_gate_template.md` and include:

- Gate result
- Unmet criteria
- Condition owners and due dates (when conditional-pass)
- Links to quality checklist evidence

## Where to Record Gate Decisions

- Session review file under `sessions/`
- Summary pointer in `IDEA_CATALOG.md`
- Final confirmation in export packet section "Governance Review"

## Compliance Example

- Run pre-export review checklist.
- If `conditional-pass`, include owner and due date for each condition.
- Create export only after recording gate outcome.
- Run `/lab audit` to verify governance integrity after export.
