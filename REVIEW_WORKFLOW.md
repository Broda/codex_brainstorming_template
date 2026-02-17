# Review Workflow

## What This Workflow Enforces

- A lightweight, repeatable quality review cycle before export.
- Explicit review decisions and evidence.
- Gate-based readiness for finalization.

## Why This Exists

It prevents incomplete or low-confidence plans from being exported and passed downstream.

## Workflow Stages

1. Intake Review
- Validate idea completeness in `ideas/_inbox.md`.
- Confirm owner and problem statement clarity.

2. Active Evaluation
- Track decisions, risks, and milestone checks in session records.
- Create ADRs for Level 3 decisions.

3. Pre-Export Review
- Run `QUALITY_BAR.md` checklist.
- Resolve or assign owners to open questions.
- Verify linked ADR and risk coverage.

4. Export Review
- Populate project plan packet template.
- Review for internal consistency and traceability.
- Record review evidence using `templates/review_gate_template.md`.

5. Finalize
- Create immutable export in `exports/`.
- Update `IDEA_CATALOG.md` status to `exported`.
- Run `/lab audit` (`scripts/validate-governance.ps1`).

## Review Gate Structure (Required)

For `/lab review`, use `templates/review_gate_template.md` and include:

- Gate result: `pass` | `conditional-pass` | `fail`
- Unmet criteria
- Owner + due date for each condition
- Links to checklist evidence

## Ready-to-Finalize Checklist

- MVP scope is explicit and bounded.
- Risks are listed with mitigation and contingency.
- Open questions are resolved or owner-assigned with due dates.
- Decision rationale is documented and linked to ADRs where required.
- Dependencies and assumptions are explicit.

## How to Comply (Example)

- Use a session file: `sessions/2026-02-17_session_review-idea-alpha.md`
- Include review outcome: `approve`, `revise`, `park`, or `kill`
- If `approve`, produce export and update indexes in same change set.

## Artifact Locations

- Review evidence: `sessions/`
- Review structure template: `templates/review_gate_template.md`
- Final packet: `exports/`
- Quality gate criteria: `QUALITY_BAR.md`
