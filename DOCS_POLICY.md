# Documentation Policy

## What This Policy Enforces

- Common structure and quality for all repository docs.
- Naming conventions and ownership metadata.
- Minimum documentation completeness before export.

## Why This Exists

Consistent documentation enables quick review, fewer interpretation errors, and reliable handoff to build repositories.

## Standards

- Date format: `YYYY-MM-DD`
- IDs: use stable IDs (`idea-<kebab-case>`, `risk-<nnn>`, `decision-<nnn>`)
- ADR IDs: `ADR-XXXX`
- Project codenames: kebab case
- File names: lowercase kebab case unless system files are already uppercase (`README.md`, `FILE_MAP.md`)

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

## How to Comply (Example)

1. Add new idea entry using `templates/idea_template.md`.
2. Link any strategic decision ADR in the idea entry.
3. Update `IDEA_CATALOG.md` with status and references.
4. Update `FILE_MAP.md` last-modified value for changed files.

## Artifact Locations

- Governance docs: repository root
- Templates: `templates/`
- ADRs: `docs/adr/`
- Sessions: `sessions/`
- Exports: `exports/`
