# Governance Index

Central index for governance, policy, standards, and process documents.

## Core Governance Docs

| Document | Enforces | Primary Use |
|---|---|---|
| `DECISION_POLICY.md` | Decision levels, ADR requirements, supersedence rules | Determine when to create ADRs and how to track decision evolution |
| `DOCS_POLICY.md` | Documentation standards, naming, ownership, quality checks | Keep records consistent and auditable |
| `REVIEW_WORKFLOW.md` | Review cycle, quality gates, readiness criteria | Verify idea maturity before export |
| `SECURITY_POLICY.md` | Sensitivity handling and safe documentation rules | Prevent accidental exposure of sensitive details |
| `QUALITY_BAR.md` | Final plan quality criteria and acceptance thresholds | Gate exports and finalization |
| `STANDARDS.md` | ID formats and lifecycle transition block contract | Normalize IDs and state transitions |

## Operational Docs

| Document | Purpose |
|---|---|
| `COMMANDS.md` | Defines governance-aware `/lab` command behaviors and required file mutations |
| `IDEA_LAB_CONTEXT.md` | Context and update rules for day-to-day operations |
| `IDEA_CATALOG.md` | Canonical index of idea records and related governance artifacts |
| `FILE_MAP.md` | Registry of managed files with purpose, owner, and last-modified timestamp |
| `QUICKSTART.md` | Happy-path implementation workflow for first-time users |

## Decision Artifacts

| Path | Purpose |
|---|---|
| `docs/adr/template.md` | Canonical ADR format (single source of truth) |
| `docs/adr/ADR-0001-adopt-governance-structure-for-idea-lab.md` | Governing decision for this repository evolution |

## Templates

| Path | Purpose |
|---|---|
| `templates/idea_template.md` | Governance-heavy idea intake and tracking |
| `templates/decision_template.md` | Session-level decision record |
| `templates/review_gate_template.md` | Standardized review gate evidence structure |
| `templates/project_plan_packet_template.md` | Final governance-aware export packet |
| `templates/adr_template.md` | Pointer doc to canonical ADR template |

## Tooling

| Path | Purpose |
|---|---|
| `scripts/validate-governance.ps1` | Non-destructive governance integrity checker for `/lab audit` |

## Onboarding Examples

| Path | Purpose |
|---|---|
| `examples/idea-example.md` | Example governed idea record |
| `examples/adr-example.md` | Example ADR entry |
| `examples/export-example.md` | Shortened export packet example |

## Where to Put Artifacts

- New strategic/architectural decision: `docs/adr/ADR-XXXX-<slug>.md`
- Idea intake or status movement: `ideas/_*.md` plus `IDEA_CATALOG.md`
- Review evidence: `sessions/YYYY-MM-DD_session_<topic>.md` using `templates/review_gate_template.md`
- Final handoff packet: `exports/YYYY-MM-DD_PROJECT_PLAN_PACKET_<idea-id>.md`
