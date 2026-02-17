# ADR-0002: Export Gate Adjustment Example

- Status: Proposed
- Date: 2026-02-17
- Deciders: idea-lab-maintainer
- Technical Story: Example ADR used by documentation and quickstart for governance walkthrough.
- Related Ideas: idea-agentic-briefing-lab
- Supersedes:
- Superseded by:

## Context and Problem Statement

This ADR exists as a realistic placeholder for quickstart and policy examples that reference an ADR beyond ADR-0001.

## Decision Drivers

- Keep examples link-valid for `/lab audit`
- Demonstrate ADR sequence continuation

## Considered Options

1. Keep unresolved references
- Pros: less files
- Cons: audit failures

2. Add a concrete example ADR
- Pros: no broken links, clearer onboarding
- Cons: one additional example artifact

## Decision Outcome

Add ADR-0002 as a proposed example artifact used by quickstart and policy examples.

## Consequences

### Positive

- Governance validation passes for template repository users.
- Documentation examples are fully resolvable.

### Negative

- Slightly larger docs footprint.

### Neutral

- No change to accepted governance policy.

## Implementation Notes

- Required updates: none
- Affected files: `DECISION_POLICY.md`, `QUICKSTART.md`, `IDEA_CATALOG.md` references remain valid
- Follow-up actions: replace with real ADR-0002 when the first post-bootstrap strategic decision is made
