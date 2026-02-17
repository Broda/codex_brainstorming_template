# ADR Example

- Status: Proposed
- Date: 2026-02-17
- Deciders: idea-lab-maintainer
- Technical Story: Define risk scoring policy for exports.
- Related Ideas: idea-agentic-briefing-lab
- Supersedes:
- Superseded by:

## Context and Problem Statement

Risk entries exist, but score interpretation is inconsistent across sessions.

## Decision Drivers

- Consistent prioritization
- Faster review gating
- Better handoff clarity

## Considered Options

1. Three-level score only
- Pros: simple
- Cons: coarse

2. Probability x impact matrix
- Pros: more precise
- Cons: slightly more overhead

## Decision Outcome

Adopt a simple probability x impact score for active ideas.

## Consequences

### Positive

- Comparable risk prioritization across ideas.

### Negative

- Requires template update and reviewer training.

## Implementation Notes

- Required updates: `templates/risk_template.md`, `QUALITY_BAR.md`
- Affected files: governance docs and future session logs
- Follow-up actions: create accepted ADR if validated in two cycles
