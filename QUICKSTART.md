# Quickstart

End-to-end happy path for one idea using the balanced governance flow.

## Goal

Demonstrate: capture -> activate -> decide -> risk -> review -> export -> finalize.

## Example IDs

- Idea ID: `idea-agentic-briefing-lab`
- Decision ID: `decision-001`
- Risk ID: `risk-001`
- ADR: `ADR-0002-export-gate-adjustment.md`

## 1) Capture

Files touched:
- `ideas/_inbox.md`
- `IDEA_CATALOG.md`

Action:
- Add idea entry with `templates/idea_template.md`.
- Add catalog row with status `inbox`.

## 2) Activate

Files touched:
- `ideas/_active.md`
- `sessions/2026-02-17_session_activate-idea-agentic-briefing-lab.md`
- `IDEA_CATALOG.md`

Action:
- Record lifecycle transition block from `inbox` to `active`.
- Create session file and link it in the catalog.

## 3) Decide

Files touched:
- `sessions/2026-02-17_session_activate-idea-agentic-briefing-lab.md`
- `docs/adr/ADR-0002-export-gate-adjustment.md` (if L3)
- `IDEA_CATALOG.md`

Action:
- Use `templates/decision_template.md` for L1/L2.
- For L3, create ADR from `docs/adr/template.md` and link it in catalog.

## 4) Risk

Files touched:
- `sessions/2026-02-17_session_risk-idea-agentic-briefing-lab.md`
- `IDEA_CATALOG.md`

Action:
- Add risk entry using `templates/risk_template.md`.

## 5) Review

Files touched:
- `sessions/2026-02-17_session_review-idea-agentic-briefing-lab.md`
- `IDEA_CATALOG.md`

Action:
- Add review gate output using `templates/review_gate_template.md`.
- Set gate outcome (`pass|conditional-pass|fail`) and owners for conditions.

## 6) Export

Files touched:
- `exports/2026-02-17_PROJECT_PLAN_PACKET_idea-agentic-briefing-lab.md`
- `IDEA_CATALOG.md`

Action:
- Create export with `templates/project_plan_packet_template.md`.
- Include governance review and quality checklist references.

## 7) Finalize

Files touched:
- `ideas/_active.md` and relevant state file
- `IDEA_CATALOG.md`

Action:
- Mark status `exported` and record transition block.
- Confirm export path and final review date in catalog.

## 8) Audit

Files touched:
- none (read-only check)

Command:
```powershell
./scripts/validate-governance.ps1
```

Expected result:
- No unresolved links, missing artifacts, or catalog/state mismatches.

## Onboarding Examples

- `examples/idea-example.md`
- `examples/adr-example.md`
- `examples/export-example.md`

