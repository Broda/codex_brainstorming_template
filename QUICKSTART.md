# Quickstart

New-repo runbook for this template repository.

## Phase A: Initialize (30-45 min)

1. Create repository from template.
2. Update `README.md` purpose line and ownership defaults.
3. Complete `BOOTSTRAP_CHECKLIST.md`.
4. Open `IDEA_CATALOG.md` and verify starter row conventions.
5. Run audit:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/validate-governance.ps1
```

## Phase B: First Idea Lifecycle (Happy Path)

### 1) Capture

Files touched:
- `ideas/_inbox.md`
- `IDEA_CATALOG.md`

Action:
- Add idea entry with `templates/idea_template.md`.
- Add catalog row with status `inbox`.

### 2) Activate

Files touched:
- `ideas/_active.md`
- `sessions/YYYY-MM-DD_session_activate-<idea>.md`
- `IDEA_CATALOG.md`

Action:
- Record lifecycle transition block from `STANDARDS.md`.
- Create activation session file and link it in catalog.

### 3) Decide

Files touched:
- `sessions/YYYY-MM-DD_session_<topic>.md`
- `docs/adr/ADR-XXXX-<slug>.md` (if Level 3)
- `IDEA_CATALOG.md`

Action:
- L1/L2: record session decision using `templates/decision_template.md`.
- L3: create ADR from `docs/adr/template.md` and link it.

### 4) Risk

Files touched:
- `sessions/YYYY-MM-DD_session_risk-<idea>.md`
- `IDEA_CATALOG.md`

Action:
- Add risk record using `templates/risk_template.md`.

### 5) Review

Files touched:
- `sessions/YYYY-MM-DD_session_review-<idea>.md`
- `IDEA_CATALOG.md`

Action:
- Add review gate output using `templates/review_gate_template.md`.
- Set `pass | conditional-pass | fail` with owner/due for conditions.

### 6) Export

Files touched:
- `exports/YYYY-MM-DD_PROJECT_PLAN_PACKET_<idea-id>.md`
- `IDEA_CATALOG.md`

Action:
- Create export with `templates/project_plan_packet_template.md`.
- Include governance review and quality checklist evidence.

### 7) Finalize

Files touched:
- relevant `ideas/_*.md` state file(s)
- `IDEA_CATALOG.md`

Action:
- Mark status `exported`.
- Record transition block and final review metadata.

### 8) Audit Again

Command:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/validate-governance.ps1
```

Expected result:
- No unresolved links, missing artifacts, or catalog/state mismatches.

## Phase C: Ongoing Operating Rhythm

- Weekly:
  - review active ideas,
  - check parked re-entry dates,
  - review unresolved high risks.
- Per governance-changing decision:
  - add ADR,
  - update affected docs and catalog links.
- Per export:
  - ensure gate evidence and ownership fields are complete.

## Onboarding Examples

- `examples/idea-example.md`
- `examples/adr-example.md`
- `examples/export-example.md`
