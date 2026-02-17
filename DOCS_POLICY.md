# Documentation Policy

## What This Policy Enforces

- Common structure and quality for all repository docs.
- Naming conventions and ownership metadata.
- Minimum documentation completeness before export.
- Catalog synchronization during lifecycle transitions.

## Why This Exists

Consistent documentation enables quick review, fewer interpretation errors, and reliable handoff to build repositories.

## Standards

- Date format: `YYYY-MM-DD`
- IDs: use stable IDs (`idea-<kebab-case>`, `decision-<nnn>`, `risk-<nnn>`, `ADR-<nnnn>`)
- Project codenames: kebab case
- File names: lowercase kebab case unless system files are already uppercase (`README.md`, `FILE_MAP.md`)
- Lifecycle transitions: must use transition block from `STANDARDS.md`

## Quality Expectations

Every substantive record must include:

- Owner
- Date
- Status
- Linked artifacts (ideas, ADRs, sessions, risks, exports)
- Next action or explicit closure condition

## Ownership

- Default owner for governance docs: `idea-lab-maintainer`
- Idea-specific owner: author or assignee in the idea record
- Export owner: person finalizing handoff packet

## Catalog Synchronization Requirement

When state transitions occur in `ideas/_*.md`, update `IDEA_CATALOG.md` in the same change set with:

- Status
- Current Gate
- Next Action Owner
- Next Action Due
- Last Reviewed
- Updated links (sessions, ADRs, export) when relevant

## How to Comply (Example)

1. Add or move idea entry.
2. Record transition block per `STANDARDS.md`.
3. Update `IDEA_CATALOG.md` in same change set.
4. Update `FILE_MAP.md` last-modified entries.
5. Run `scripts/validate-governance.ps1`.

## Artifact Locations

- Governance docs: repository root
- Templates: `templates/`
- ADRs: `docs/adr/`
- Sessions: `sessions/`
- Exports: `exports/`
- Audit script: `scripts/validate-governance.ps1`
