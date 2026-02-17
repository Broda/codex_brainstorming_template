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
- Record approval decision in session file.

5. Finalize
- Create immutable export in `exports/`.
- Update `IDEA_CATALOG.md` status to `exported`.

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
- Final packet: `exports/`
- Quality gate criteria: `QUALITY_BAR.md`
