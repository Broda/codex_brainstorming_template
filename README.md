# Project Idea Lab

Governance-structured repository for brainstorming, evaluating, refining, and exporting project ideas into a final `PROJECT_PLAN_PACKET` for handoff to a build repository.

## Core Workflow

1. Capture ideas in `ideas/_inbox.md` using `templates/idea_template.md`.
2. Promote viable ideas to `ideas/_active.md` with a session log in `sessions/`.
3. Record strategic decisions as ADRs in `docs/adr/` and link them from idea records.
4. Track risks, milestones, and review outcomes until quality gates are met.
5. Export approved plans to `exports/` using `templates/project_plan_packet_template.md`.
6. Finalize and run governance audit checks via `scripts/validate-governance.ps1`.

## Governance Approach

Governance is explicit and file-based. Policies define quality, decision rigor, and review controls.

- Governance index: `GOVERNANCE_INDEX.md`
- Decision policy: `DECISION_POLICY.md`
- Documentation policy: `DOCS_POLICY.md`
- Review workflow: `REVIEW_WORKFLOW.md`
- Security policy: `SECURITY_POLICY.md`
- Quality bar: `QUALITY_BAR.md`
- Standards (IDs + transitions): `STANDARDS.md`
- Command contract: `COMMANDS.md`
- File registry: `FILE_MAP.md`

## ADR System

- ADR folder: `docs/adr/`
- Canonical ADR template (single source): `docs/adr/template.md`
- Initial repository decision: `docs/adr/ADR-0001-adopt-governance-structure-for-idea-lab.md`

## Catalogs and Working Data

- Idea catalog: `IDEA_CATALOG.md`
- Idea state files: `ideas/_inbox.md`, `ideas/_active.md`, `ideas/_parked.md`, `ideas/_killed.md`
- Onboarding quickstart: `QUICKSTART.md`
- Worked examples: `examples/idea-example.md`, `examples/adr-example.md`, `examples/export-example.md`

## Baseline Rules

- Never delete historical records.
- Always timestamp changes (`YYYY-MM-DD`).
- Always update affected indexes when adding or changing artifacts.
- Exports are immutable snapshots; revisions create a new export file.
- Use `STANDARDS.md` transition blocks for lifecycle moves.
- Run `/lab audit` (or `scripts/validate-governance.ps1`) after governance-impacting updates.
