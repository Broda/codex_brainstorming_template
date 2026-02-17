# Bootstrap Checklist

Use this checklist immediately after creating a new repository from this template.

## 1) Repository Identity

- [ ] Set repository purpose statement in `README.md`.
- [ ] Confirm default governance owner (replace `idea-lab-maintainer` where needed).
- [ ] Confirm license/readme messaging for public open-source usage.

## 2) Operating Defaults

- [ ] Set default sensitivity profile for the repo (`Public` / `Internal` / `Restricted`) and document in `SECURITY_POLICY.md` notes.
- [ ] Confirm workflow preference (solo-first, team-ready) in `WORKING_AGREEMENTS.md`.
- [ ] Confirm review cadence in `WORKING_AGREEMENTS.md`.

## 3) First Governance Actions

- [ ] Run first `/lab capture` for a real starter idea.
- [ ] Add starter row details in `IDEA_CATALOG.md`.
- [ ] Create first session file in `sessions/`.

## 4) Validation

Run audit locally:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/validate-governance.ps1
```

- [ ] Zero blocking failures.
- [ ] Resolve warnings or explicitly document deferred fixes.

## 5) Public Contribution Setup

- [ ] Confirm `.github/ISSUE_TEMPLATE/idea-intake.md` and `.github/ISSUE_TEMPLATE/governance-change.md` fit your contribution model.
- [ ] Confirm `.github/PULL_REQUEST_TEMPLATE.md` required evidence fields are aligned with governance expectations.
- [ ] Confirm `.github/workflows/governance-audit.yml` is active for pull requests.

## Done Criteria

Bootstrap is complete when:
- repository identity is set,
- first idea is captured,
- audit is passing,
- contribution and CI governance surfaces are enabled.
