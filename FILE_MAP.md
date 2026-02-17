# File Map

Managed file registry for the governance-structured Project Idea Lab.

Owner legend:
- `idea-lab-maintainer`: repository governance owner

## File Registry

| Path | Purpose | Owner | Last Modified |
|---|---|---|---|
| `README.md` | Repo overview and governance entrypoint | idea-lab-maintainer | 2026-02-17 |
| `IDEA_LAB_CONTEXT.md` | Operating context and update rules | idea-lab-maintainer | 2026-02-17 |
| `COMMANDS.md` | Governance-aware command definitions | idea-lab-maintainer | 2026-02-17 |
| `FILE_MAP.md` | Managed file index and metadata | idea-lab-maintainer | 2026-02-17 |
| `GOVERNANCE_INDEX.md` | Index of governance and policy docs | idea-lab-maintainer | 2026-02-17 |
| `DECISION_POLICY.md` | Decision levels, ADR rules, supersedence | idea-lab-maintainer | 2026-02-17 |
| `DOCS_POLICY.md` | Documentation standards and ownership | idea-lab-maintainer | 2026-02-17 |
| `REVIEW_WORKFLOW.md` | Review lifecycle and readiness checks | idea-lab-maintainer | 2026-02-17 |
| `SECURITY_POLICY.md` | Sensitivity and secure documentation guidance | idea-lab-maintainer | 2026-02-17 |
| `QUALITY_BAR.md` | Export quality gates and acceptance criteria | idea-lab-maintainer | 2026-02-17 |
| `STANDARDS.md` | ID patterns and lifecycle transition requirements | idea-lab-maintainer | 2026-02-17 |
| `WORKING_AGREEMENTS.md` | Team operating agreements and cadence | idea-lab-maintainer | 2026-02-17 |
| `GLOSSARY.md` | Governance vocabulary normalization | idea-lab-maintainer | 2026-02-17 |
| `METRICS.md` | Planning quality and throughput metrics dashboard | idea-lab-maintainer | 2026-02-17 |
| `TEMPLATE_RELEASES.md` | Template versioning and migration policy | idea-lab-maintainer | 2026-02-17 |
| `QUICKSTART.md` | Happy-path onboarding workflow | idea-lab-maintainer | 2026-02-17 |
| `BOOTSTRAP_CHECKLIST.md` | First-use initialization checklist | idea-lab-maintainer | 2026-02-17 |
| `IDEA_CATALOG.md` | Central index of ideas and governance links | idea-lab-maintainer | 2026-02-17 |
| `ideas/_inbox.md` | Inbox state for new ideas | idea-lab-maintainer | 2026-02-17 |
| `ideas/_active.md` | Active ideas under evaluation | idea-lab-maintainer | 2026-02-17 |
| `ideas/_parked.md` | Deferred ideas and re-entry criteria | idea-lab-maintainer | 2026-02-17 |
| `ideas/_killed.md` | Rejected ideas and rationale | idea-lab-maintainer | 2026-02-17 |
| `sessions/` | Session logs for reviews, decisions, and risks | idea-lab-maintainer | 2026-02-17 |
| `templates/idea_template.md` | Governance-heavy idea template | idea-lab-maintainer | 2026-02-17 |
| `templates/decision_template.md` | Governance decision template | idea-lab-maintainer | 2026-02-17 |
| `templates/risk_template.md` | Risk template | idea-lab-maintainer | 2026-02-17 |
| `templates/milestone_template.md` | Milestone template | idea-lab-maintainer | 2026-02-17 |
| `templates/review_gate_template.md` | Standard review gate evidence template | idea-lab-maintainer | 2026-02-17 |
| `templates/adr_template.md` | Pointer to canonical ADR template | idea-lab-maintainer | 2026-02-17 |
| `templates/project_plan_packet_template.md` | Governance export packet template | idea-lab-maintainer | 2026-02-17 |
| `exports/` | Immutable finalized project plan packets | idea-lab-maintainer | 2026-02-17 |
| `docs/adr/template.md` | Canonical ADR template | idea-lab-maintainer | 2026-02-17 |
| `docs/adr/ADR-0001-adopt-governance-structure-for-idea-lab.md` | Initial governance adoption ADR | idea-lab-maintainer | 2026-02-17 |
| `docs/adr/ADR-0002-export-gate-adjustment.md` | Example follow-on ADR for governance walkthroughs | idea-lab-maintainer | 2026-02-17 |
| `scripts/validate-governance.ps1` | Governance integrity checks for `/lab audit` | idea-lab-maintainer | 2026-02-17 |
| `.github/workflows/governance-audit.yml` | Warn-only governance CI check | idea-lab-maintainer | 2026-02-17 |
| `.github/ISSUE_TEMPLATE/idea-intake.md` | Idea intake issue template | idea-lab-maintainer | 2026-02-17 |
| `.github/ISSUE_TEMPLATE/governance-change.md` | Governance change issue template | idea-lab-maintainer | 2026-02-17 |
| `.github/PULL_REQUEST_TEMPLATE.md` | PR governance evidence checklist | idea-lab-maintainer | 2026-02-17 |
| `examples/idea-example.md` | Example governed idea entry | idea-lab-maintainer | 2026-02-17 |
| `examples/adr-example.md` | Example ADR entry | idea-lab-maintainer | 2026-02-17 |
| `examples/export-example.md` | Example shortened export packet | idea-lab-maintainer | 2026-02-17 |

## Notes

- Git internals under `.git/` are intentionally excluded from this managed registry.
- Update this table whenever adding, renaming, or materially changing managed files.
- `/lab audit` flags stale date coverage and missing governance artifacts as part of hygiene checks.
