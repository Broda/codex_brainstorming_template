# Governance Index

Central index for governance, policy, and process documents.

## Core Governance Docs

| Document | Enforces | Primary Use |
|---|---|---|
| `DECISION_POLICY.md` | Decision levels, ADR requirements, supersedence rules | Determine when to create ADRs and how to track decision evolution |
| `DOCS_POLICY.md` | Documentation standards, naming, ownership, quality checks | Keep records consistent and auditable |
| `REVIEW_WORKFLOW.md` | Review cycle, quality gates, readiness criteria | Verify idea maturity before export |
| `SECURITY_POLICY.md` | Sensitivity handling and safe documentation rules | Prevent accidental exposure of sensitive details |
| `QUALITY_BAR.md` | Final plan quality criteria and acceptance thresholds | Gate exports and finalization |

## Operational Docs

| Document | Purpose |
|---|---|
| `COMMANDS.md` | Defines governance-aware `/lab` command behaviors and required file mutations |
| `IDEA_LAB_CONTEXT.md` | Context and update rules for day-to-day operations |
| `IDEA_CATALOG.md` | Canonical index of idea records and related governance artifacts |
| `FILE_MAP.md` | Registry of managed files with purpose, owner, and last-modified timestamp |

## Decision Artifacts

| Path | Purpose |
|---|---|
| `docs/adr/template.md` | Standard ADR format |
| `docs/adr/ADR-0001-adopt-governance-structure-for-idea-lab.md` | Governing decision for this repository evolution |

## Where to Put Artifacts

- New strategic/architectural decision: `docs/adr/ADR-XXXX-<slug>.md`
- Idea intake or status movement: `ideas/_*.md` plus `IDEA_CATALOG.md`
- Review evidence: `sessions/YYYY-MM-DD_session_<topic>.md`
- Final handoff packet: `exports/YYYY-MM-DD_PROJECT_PLAN_PACKET_<idea-id>.md`
