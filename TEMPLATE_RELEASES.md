# Template Releases Policy

Versioning and release notes policy for this public template repository.

## Versioning Scheme

Use semver-like template tags:
- `template-vMAJOR.MINOR.PATCH`

Meaning:
- MAJOR: Breaking governance contract or required artifact changes.
- MINOR: Backward-compatible additions (new docs/templates/scripts/workflows).
- PATCH: Clarifications, typo fixes, non-breaking policy tightening.

## Release Notes Requirements

Each release note entry should include:
- Version tag
- Date
- Summary
- Added/Changed/Removed sections
- Migration notes
- Compatibility notes

## Migration Notes

When behavior changes, include exact migration actions, including:
- files to create/update,
- command contract updates,
- required re-audit steps.

## Compatibility Notes

Call out impacts to:
- `COMMANDS.md` workflows,
- template field requirements,
- audit script expectations,
- CI workflow behavior.

## Release Entry Template

```md
## template-vX.Y.Z - YYYY-MM-DD
### Added
- 

### Changed
- 

### Removed
- 

### Migration Notes
- 

### Compatibility Notes
- 
```
