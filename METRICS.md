# Metrics

Lightweight dashboard metrics for planning quality and throughput.

## Core Metrics

1. Total ideas by state
- Count of `inbox`, `active`, `parked`, `killed`, `exported` from `IDEA_CATALOG.md`.

2. Average days in active
- Mean duration from `active` transition date to export/park/kill.

3. Conditional-pass export rate
- `% exports with conditional-pass` = conditional-pass exports / total exports.

4. Unresolved high-risk count
- Number of high-impact open risks without mitigation completion.

## Tracking Cadence

- Weekly snapshot update.
- Monthly trend review for process adjustments.

## Data Sources

- `IDEA_CATALOG.md`
- `sessions/` review records
- `exports/` governance review sections

## Reporting Format

Use this section format for each reporting period:

```md
## YYYY-MM-DD Weekly Snapshot
- Total ideas by state:
- Average days in active:
- Conditional-pass export rate:
- Unresolved high-risk count:
- Notes/actions:
```

## Usage

Use metrics for process tuning, not punitive scoring.
