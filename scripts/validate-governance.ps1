param(
    [switch]$VerboseOutput
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Get-Location).Path
$failures = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

function Add-Failure([string]$msg) {
    $script:failures.Add($msg)
}

function Add-Warning([string]$msg) {
    $script:warnings.Add($msg)
}

function Test-PathSafe([string]$path) {
    if ([string]::IsNullOrWhiteSpace($path)) { return $false }
    return Test-Path -LiteralPath $path
}

# 1) ADR links resolve
$markdownFiles = Get-ChildItem -Recurse -File -Filter *.md | Where-Object { $_.FullName -notmatch '\.git\\' }
$adrRegex = [regex]'docs/adr/ADR-[0-9]{4}-[a-z0-9-]+\.md'

foreach ($file in $markdownFiles) {
    $content = Get-Content -Raw -LiteralPath $file.FullName
    $matches = $adrRegex.Matches($content)
    foreach ($m in $matches) {
        $relative = $m.Value.Replace('/', '\\')
        if (-not (Test-PathSafe $relative)) {
            Add-Failure("Missing ADR link target: '$relative' referenced in '$($file.FullName)'.")
        }
    }
}

# 2) Catalog status maps to state files and required artifacts
$catalogPath = 'IDEA_CATALOG.md'
if (-not (Test-PathSafe $catalogPath)) {
    Add-Failure('Missing IDEA_CATALOG.md')
} else {
    $catalog = Get-Content -Raw -LiteralPath $catalogPath
    $rows = $catalog -split "`n" | Where-Object { $_ -match '^\|\s*idea-[a-z0-9-]+' }

    foreach ($row in $rows) {
        $cols = $row.Split('|') | ForEach-Object { $_.Trim() }
        # indexes after split: 0 empty, 1 idea id, 2 title, 3 status, 4 owner, 5 adrs, 6 sessions, 7 export, 8 gate, 9 next owner, 10 next due, 11 last reviewed, 12 notes
        if ($cols.Count -lt 12) {
            Add-Failure("Malformed catalog row: $row")
            continue
        }

        $ideaId = $cols[1]
        $status = $cols[3]
        $sessions = $cols[6]
        $export = $cols[7]
        $gate = $cols[8]

        switch ($status) {
            'inbox' {
                $stateFile = 'ideas/_inbox.md'
            }
            'active' {
                $stateFile = 'ideas/_active.md'
                if ($sessions -match '_none_|_none yet_|n/a') {
                    Add-Failure("Active idea '$ideaId' must have at least one linked session.")
                }
            }
            'parked' {
                $stateFile = 'ideas/_parked.md'
            }
            'killed' {
                $stateFile = 'ideas/_killed.md'
            }
            'exported' {
                $stateFile = 'ideas/_active.md'
                if ($export -match '_n/a_|_none_|_none yet_' -or [string]::IsNullOrWhiteSpace($export)) {
                    Add-Failure("Exported idea '$ideaId' must include export file path.")
                }
            }
            default {
                Add-Failure("Unknown status '$status' for '$ideaId'.")
                continue
            }
        }

        if (-not (Test-PathSafe $stateFile)) {
            Add-Failure("Required state file '$stateFile' missing for status '$status'.")
        } else {
            $stateContent = Get-Content -Raw -LiteralPath $stateFile
            if ($stateContent -notmatch [regex]::Escape($ideaId)) {
                Add-Warning("Idea '$ideaId' not found in expected state file '$stateFile'.")
            }
        }

        if ($status -eq 'exported' -and $export -notmatch '_n/a_|_none_') {
            $exportPath = $export.Trim('`', ' ')
            $exportPath = $exportPath.Replace('/', '\\')
            if (-not (Test-PathSafe $exportPath)) {
                Add-Failure("Catalog export path missing for '$ideaId': $exportPath")
            }
        }

        if ($status -eq 'active' -and $gate -eq 'fail') {
            Add-Warning("Active idea '$ideaId' currently has gate 'fail'.")
        }
    }
}

# 3) Command-required artifacts present
$requiredArtifacts = @(
    'COMMANDS.md',
    'DECISION_POLICY.md',
    'DOCS_POLICY.md',
    'REVIEW_WORKFLOW.md',
    'QUALITY_BAR.md',
    'GOVERNANCE_INDEX.md',
    'STANDARDS.md',
    'QUICKSTART.md',
    'templates/review_gate_template.md',
    'docs/adr/template.md'
)

foreach ($artifact in $requiredArtifacts) {
    $path = $artifact.Replace('/', '\\')
    if (-not (Test-PathSafe $path)) {
        Add-Failure("Required artifact missing: $artifact")
    }
}

# 4) FILE_MAP freshness advisory
$fileMapPath = 'FILE_MAP.md'
if (-not (Test-PathSafe $fileMapPath)) {
    Add-Failure('Missing FILE_MAP.md')
} else {
    $fm = Get-Content -Raw -LiteralPath $fileMapPath
    foreach ($artifact in $requiredArtifacts) {
        if ($fm -notmatch [regex]::Escape($artifact)) {
            Add-Warning("FILE_MAP.md missing registry row for: $artifact")
        }
    }
    if ($fm -notmatch '/lab audit|validate-governance') {
        Add-Warning('FILE_MAP.md should mention /lab audit stale-date checks.')
    }
}

Write-Host 'Governance validation summary'
Write-Host "- Failures: $($failures.Count)"
Write-Host "- Warnings: $($warnings.Count)"

if ($warnings.Count -gt 0) {
    Write-Host "`nWarnings:"
    $warnings | ForEach-Object { Write-Host "- $_" }
}

if ($failures.Count -gt 0) {
    Write-Host "`nFailures:"
    $failures | ForEach-Object { Write-Host "- $_" }
    exit 1
}

Write-Host "`nPASS: governance checks completed with no blocking failures."
