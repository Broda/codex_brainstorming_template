param(
    [Parameter(Mandatory = $true)]
    [string]$IdeaId,
    [string]$Dest,
    [ValidateSet('prompt','yes','no')]
    [string]$Init = 'prompt'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$TemplateSsh = 'git@github.com:Broda/codex_template.git'
$TemplateHttps = 'https://github.com/Broda/codex_template.git'
$MilestoneName = 'Milestone 0 — Foundation / Spine'

function Read-Trim([string]$prompt) {
    $raw = Read-Host $prompt
    if ($null -eq $raw) { return '' }
    return $raw.Trim()
}

function Ask-YesNo([string]$prompt, [bool]$defaultNo = $true) {
    while ($true) {
        $suffix = if ($defaultNo) { '[y/N]' } else { '[Y/n]' }
        $answer = (Read-Host "$prompt $suffix").Trim().ToLowerInvariant()
        if ([string]::IsNullOrWhiteSpace($answer)) { return -not $defaultNo }
        if ($answer -in @('y','yes')) { return $true }
        if ($answer -in @('n','no')) { return $false }
    }
}

function To-Kebab([string]$value) {
    $k = $value.ToLowerInvariant() -replace '[^a-z0-9]+','-'
    $k = $k -replace '^-+','' -replace '-+$','' -replace '-+','-'
    if ([string]::IsNullOrWhiteSpace($k)) { return 'project' }
    return $k
}

function Replace-LinePrefix([string]$path, [string]$prefix, [string]$value) {
    $lines = Get-Content -LiteralPath $path
    $updated = foreach ($line in $lines) {
        if ($line.StartsWith($prefix)) { "$prefix $value" } else { $line }
    }
    Set-Content -LiteralPath $path -Value $updated
}

function Replace-Literals([string]$path, [hashtable]$map) {
    $content = Get-Content -Raw -LiteralPath $path
    foreach ($k in $map.Keys) {
        $content = $content.Replace($k, [string]$map[$k])
    }
    Set-Content -LiteralPath $path -Value $content
}

function Copy-Base([string]$src, [string]$dst) {
    New-Item -ItemType Directory -Path (Split-Path -Parent $dst) -Force | Out-Null
    Copy-Item -LiteralPath $src -Destination $dst -Force
}

function Choose-From([string]$prompt, [string[]]$options) {
    for ($i = 0; $i -lt $options.Count; $i++) {
        Write-Host ("{0}) {1}" -f ($i + 1), $options[$i])
    }
    while ($true) {
        $input = Read-Trim "$prompt [1-$($options.Count)]"
        [int]$n = 0
        if ([int]::TryParse($input, [ref]$n) -and $n -ge 1 -and $n -le $options.Count) {
            return $options[$n - 1]
        }
    }
}

function Validate-Generated([string]$root, [bool]$requiresMigration) {
    $required = @(
        'README.md',
        'docs/PROJECT_CONTEXT.md',
        'docs/ROADMAP.md',
        'docs/ARCHITECTURE.md',
        'docs/FILE_MAP.md',
        'docs/GOVERNANCE_INDEX.md',
        'docs/VERSIONING_AND_RELEASE_POLICY.md',
        'docs/SECURITY_POLICY.md',
        'docs/RUNTIME_VERIFICATION_REPORT.md',
        'docs/adr/ADR-0001-record-architecture-decisions.md',
        'docs/adr/ADR-TEMPLATE.md',
        'CHANGELOG.md',
        '.gitignore'
    )

    if ($requiresMigration) {
        $required += 'docs/MIGRATION_POLICY.md'
    }

    foreach ($rel in $required) {
        if (-not (Test-Path -LiteralPath (Join-Path $root $rel))) {
            throw "Missing generated file: $rel"
        }
    }

    $roadmap = Get-Content -Raw -LiteralPath (Join-Path $root 'docs/ROADMAP.md')
    if ($roadmap -notmatch [regex]::Escape($MilestoneName)) {
        throw "ROADMAP missing required milestone title: $MilestoneName"
    }

    $checkTargets = @(
        (Join-Path $root 'README.md'),
        (Join-Path $root 'docs'),
        (Join-Path $root 'CHANGELOG.md')
    )
    foreach ($target in $checkTargets) {
        $hits = Select-String -Path $target -Pattern '<[^>]+>' -AllMatches -ErrorAction SilentlyContinue
        if ($hits) {
            throw 'Unresolved placeholders detected in generated files.'
        }
    }
}

if (-not (Test-Path -LiteralPath 'IDEA_CATALOG.md')) {
    throw 'IDEA_CATALOG.md not found.'
}

$row = Get-Content -LiteralPath 'IDEA_CATALOG.md' | Where-Object { $_ -match "^\|\s*$([regex]::Escape($IdeaId))\s*\|" } | Select-Object -First 1
if (-not $row) {
    throw "Idea '$IdeaId' not found in IDEA_CATALOG.md."
}

$parts = $row.Split('|') | ForEach-Object { $_.Trim() }
$projectName = if ($parts[2] -and $parts[2] -ne '_none yet_') { $parts[2] } else { $IdeaId }
$owner = if ($parts[4] -and $parts[4] -ne 'unassigned') { $parts[4] } else { (git config --get user.name) }
if (-not $owner) { $owner = 'unassigned' }
$sessions = $parts[5]
$notes = $parts[7]

$dateStamp = Get-Date -Format 'yyyy-MM-dd'
New-Item -ItemType Directory -Path 'exports' -Force | Out-Null
$exportPath = "exports/${dateStamp}_PROJECT_PLAN_PACKET_${IdeaId}.md"
Copy-Item -LiteralPath 'templates/project_plan_packet_template.md' -Destination $exportPath -Force
Replace-LinePrefix -path $exportPath -prefix '- Project name:' -value $projectName
Replace-LinePrefix -path $exportPath -prefix '- Idea ID:' -value $IdeaId
Replace-LinePrefix -path $exportPath -prefix '- Owner:' -value $owner
Replace-LinePrefix -path $exportPath -prefix '- Date:' -value $dateStamp

$objective = (Get-Content -LiteralPath $exportPath | Where-Object { $_ -like '- One-sentence objective:*' } | Select-Object -First 1)
$objective = ($objective -replace '^- One-sentence objective:\s*','').Trim()

$newRow = "| $IdeaId | $projectName | exported | $owner | $sessions | `$exportPath` | $notes |"
$catalog = Get-Content -LiteralPath 'IDEA_CATALOG.md'
$catalog = $catalog | ForEach-Object {
    if ($_ -match "^\|\s*$([regex]::Escape($IdeaId))\s*\|") { $newRow } else { $_ }
}
Set-Content -LiteralPath 'IDEA_CATALOG.md' -Value $catalog

Write-Host "Project plan created: $exportPath"

$runInit = $false
switch ($Init) {
    'yes' { $runInit = $true }
    'no' { $runInit = $false }
    default { $runInit = Ask-YesNo 'Do you want to initialize a project from this plan now?' $true }
}

if (-not $runInit) {
    Write-Host 'Initialization skipped. Finalized at project plan creation.'
    exit 0
}

if (-not $Dest) {
    $defaultDest = "../$(To-Kebab $projectName)"
    Write-Host "1) Workspace sibling (recommended): $defaultDest"
    Write-Host '2) Custom path'
    while ($true) {
        $choice = Read-Trim 'Select option [1-2]'
        if ($choice -eq '1') { $Dest = $defaultDest; break }
        if ($choice -eq '2') {
            $Dest = Read-Trim 'Enter destination path'
            if ($Dest) { break }
        }
    }
}

while ($true) {
    if (Test-Path -LiteralPath $Dest) {
        Write-Host "Destination already exists: $Dest"
        Write-Host '1) Use existing folder'
        Write-Host '2) Choose a new destination'
        Write-Host '3) Abort'
        $choice = Read-Trim 'Choose recovery option [1-3]'
        if ($choice -eq '1') { break }
        if ($choice -eq '2') { $Dest = Read-Trim 'Enter new destination path'; continue }
        if ($choice -eq '3') { throw 'Initialization canceled before clone completion.' }
        continue
    }

    & git clone $TemplateSsh $Dest
    if ($LASTEXITCODE -eq 0) { break }

    Write-Host 'Clone failed for SSH URL.'
    Write-Host '1) Retry SSH'
    Write-Host '2) Retry with HTTPS'
    Write-Host '3) Choose a new destination'
    Write-Host '4) Abort'
    $choice = Read-Trim 'Choose recovery option [1-4]'
    if ($choice -eq '1') { continue }
    if ($choice -eq '2') {
        & git clone $TemplateHttps $Dest
        if ($LASTEXITCODE -eq 0) { break }
        continue
    }
    if ($choice -eq '3') { $Dest = Read-Trim 'Enter new destination path'; continue }
    if ($choice -eq '4') { throw 'Initialization canceled before clone completion.' }
}

if ((& git -C $Dest remote) -contains 'origin') {
    $oldOrigin = (& git -C $Dest remote get-url origin)
    & git -C $Dest remote remove origin
    if ($LASTEXITCODE -ne 0) { throw "Failed to remove inherited origin remote from $Dest." }
    Write-Host "Detached template remote: removed origin ($oldOrigin)"
}

$configureOrigin = Ask-YesNo 'Configure a new private repository remote as origin now?' $true
if ($configureOrigin) {
    $newOrigin = Read-Trim 'Enter new private origin URL (git@... or https://...)'
    if ($newOrigin) {
        & git -C $Dest remote add origin $newOrigin
        if ($LASTEXITCODE -ne 0) {
            Write-Warning 'Failed to set new origin remote. Repository remains without origin.'
        } else {
            Write-Host "Configured origin: $newOrigin"
        }
    } else {
        Write-Host 'No origin URL provided. Repository remains detached from any origin.'
    }
} else {
    Write-Host "Skipped origin setup. Add one later with: git -C `"$Dest`" remote add origin <your-private-repo-url>"
}

Write-Host "Template available at: $Dest"

$projectType = Choose-From 'Project type' @('CLI','Desktop','Web App','API','Library')
$language = Read-Trim 'Language'
$runtime = Read-Trim 'Runtime'
$framework = Read-Trim 'Framework (if any, else None)'; if (-not $framework) { $framework = 'None' }
$packageTool = Read-Trim 'Package manager/build tool (if any, else None)'; if (-not $packageTool) { $packageTool = 'None' }
$persistence = Choose-From 'Persistence' @('None','File-based (JSON/YAML/etc.)','SQLite','Postgres/MySQL/Other RDBMS')
$authentication = Choose-From 'Authentication' @('None','Local users','External auth provider')
$determinism = Choose-From 'Determinism/correctness sensitivity' @('Normal','High')
$packaging = Choose-From 'Packaging/distribution planned' @('None','Yes (desktop installers / containers / artifacts)')
$constraints = Read-Trim 'Constraints (freeform, or None)'; if (-not $constraints) { $constraints = 'None' }
$buildCommand = Read-Trim 'Build command'
$runCommand = Read-Trim 'Run command'
$testCommand = Read-Trim 'Test command'

$prefillPath = "exports/${dateStamp}_HANDOFF_PREFILL_${IdeaId}.json"
$prefillObj = [ordered]@{
    ideaId = $IdeaId
    projectName = $projectName
    purpose = $(if ($objective) { $objective } else { 'TBD' })
    projectType = $projectType
    techStack = [ordered]@{
        language = $language
        runtime = $runtime
        framework = $framework
        packageTool = $packageTool
    }
    persistence = $persistence
    authentication = $authentication
    determinism = $determinism
    packaging = $packaging
    constraints = $constraints
    commands = [ordered]@{
        build = $buildCommand
        run = $runCommand
        test = $testCommand
    }
    destination = $Dest
}
($prefillObj | ConvertTo-Json -Depth 5) | Set-Content -LiteralPath $prefillPath

$tpl = Join-Path $Dest 'project_init_templates'
New-Item -ItemType Directory -Path (Join-Path $Dest 'docs/adr') -Force | Out-Null

Copy-Base (Join-Path $tpl 'docs/README.base.md') (Join-Path $Dest 'README.md')
Copy-Base (Join-Path $tpl 'docs/PROJECT_CONTEXT.base.md') (Join-Path $Dest 'docs/PROJECT_CONTEXT.md')
Copy-Base (Join-Path $tpl 'docs/ROADMAP.base.md') (Join-Path $Dest 'docs/ROADMAP.md')
Copy-Base (Join-Path $tpl 'docs/ARCHITECTURE.base.md') (Join-Path $Dest 'docs/ARCHITECTURE.md')
Copy-Base (Join-Path $tpl 'docs/FILE_MAP.base.md') (Join-Path $Dest 'docs/FILE_MAP.md')
Copy-Base (Join-Path $tpl 'docs/GOVERNANCE_INDEX.base.md') (Join-Path $Dest 'docs/GOVERNANCE_INDEX.md')
Copy-Base (Join-Path $tpl 'docs/VERSIONING_AND_RELEASE_POLICY.base.md') (Join-Path $Dest 'docs/VERSIONING_AND_RELEASE_POLICY.md')
Copy-Base (Join-Path $tpl 'docs/SECURITY_POLICY.base.md') (Join-Path $Dest 'docs/SECURITY_POLICY.md')
Copy-Base (Join-Path $tpl 'docs/RUNTIME_VERIFICATION_REPORT.base.md') (Join-Path $Dest 'docs/RUNTIME_VERIFICATION_REPORT.md')
Copy-Base (Join-Path $tpl 'docs/adr/ADR-0001-record-architecture-decisions.md') (Join-Path $Dest 'docs/adr/ADR-0001-record-architecture-decisions.md')
Copy-Base (Join-Path $tpl 'docs/adr/ADR-TEMPLATE.md') (Join-Path $Dest 'docs/adr/ADR-TEMPLATE.md')
Copy-Base (Join-Path $tpl 'docs/CHANGELOG.base.md') (Join-Path $Dest 'CHANGELOG.md')

$requiresMigration = $persistence -ne 'None'
if ($requiresMigration) {
    Copy-Base (Join-Path $tpl 'docs/MIGRATION_POLICY.base.md') (Join-Path $Dest 'docs/MIGRATION_POLICY.md')
}

$langLower = $language.ToLowerInvariant()
if ($langLower -match 'python') {
    Copy-Item -LiteralPath (Join-Path $tpl 'gitignore/python.gitignore') -Destination (Join-Path $Dest '.gitignore') -Force
} elseif ($langLower -match 'node|javascript|typescript') {
    Copy-Item -LiteralPath (Join-Path $tpl 'gitignore/node.gitignore') -Destination (Join-Path $Dest '.gitignore') -Force
} elseif ($langLower -match 'c#|dotnet|\.net') {
    Copy-Item -LiteralPath (Join-Path $tpl 'gitignore/dotnet.gitignore') -Destination (Join-Path $Dest '.gitignore') -Force
} else {
    Copy-Item -LiteralPath (Join-Path $tpl 'gitignore/generic.gitignore') -Destination (Join-Path $Dest '.gitignore') -Force
}

if ($requiresMigration) {
    Add-Content -LiteralPath (Join-Path $Dest '.gitignore') -Value "`n*.db`n*.sqlite`n*.sqlite3"
}
if ($packaging -ne 'None') {
    Add-Content -LiteralPath (Join-Path $Dest '.gitignore') -Value "`n*.dmg`n*.msi`n*.AppImage`n*.deb`n*.rpm"
}

$setupSteps = "Language: $language`nRuntime: $runtime`nFramework: $framework`nTooling: $packageTool"
$purposeText = if ($objective) { $objective } else { "$projectName is initialized from brainstorming handoff." }

$filesForGlobalReplacement = @(
    (Join-Path $Dest 'README.md'),
    (Join-Path $Dest 'docs/PROJECT_CONTEXT.md'),
    (Join-Path $Dest 'docs/ROADMAP.md'),
    (Join-Path $Dest 'docs/ARCHITECTURE.md'),
    (Join-Path $Dest 'docs/FILE_MAP.md'),
    (Join-Path $Dest 'docs/GOVERNANCE_INDEX.md'),
    (Join-Path $Dest 'docs/VERSIONING_AND_RELEASE_POLICY.md'),
    (Join-Path $Dest 'docs/SECURITY_POLICY.md'),
    (Join-Path $Dest 'docs/RUNTIME_VERIFICATION_REPORT.md'),
    (Join-Path $Dest 'docs/adr/ADR-0001-record-architecture-decisions.md'),
    (Join-Path $Dest 'docs/adr/ADR-TEMPLATE.md')
)

$map = @{
    '<Project Name>' = $projectName
    '<Milestone Name>' = $MilestoneName
    '<Build command>' = $buildCommand
    '<Run command>' = $runCommand
    '<Test command>' = $testCommand
    '<Short Title>' = 'Decision Title'
}

foreach ($f in $filesForGlobalReplacement) {
    Replace-Literals -path $f -map $map
}

$readmePath = Join-Path $Dest 'README.md'
$readme = Get-Content -Raw -LiteralPath $readmePath
$readme = $readme.Replace('<Prototype / MVP / Beta>', 'MVP')
$readme = $readme.Replace('<Stack-specific setup steps>', $setupSteps)
$readme = [regex]::Replace($readme, 'Build:\s*\r?\n\s*\r?\n\s*<command>', [System.Text.RegularExpressions.MatchEvaluator]{
    param($m)
    "Build:`n`n    $buildCommand"
})
$readme = [regex]::Replace($readme, 'Run:\s*\r?\n\s*\r?\n\s*<command>', [System.Text.RegularExpressions.MatchEvaluator]{
    param($m)
    "Run:`n`n    $runCommand"
})
$readme = [regex]::Replace($readme, 'Test:\s*\r?\n\s*\r?\n\s*<command>', [System.Text.RegularExpressions.MatchEvaluator]{
    param($m)
    "Test:`n`n    $testCommand"
})
Set-Content -LiteralPath $readmePath -Value $readme

$projectContextPath = Join-Path $Dest 'docs/PROJECT_CONTEXT.md'
$pc = Get-Content -Raw -LiteralPath $projectContextPath
$pc = $pc.Replace('<Describe what this project is and why it exists.>', $purposeText)
$pc = $pc.Replace('<What comes next>', 'Deliver Milestone 0 vertical slice and validation evidence.')
Set-Content -LiteralPath $projectContextPath -Value $pc

$roadmapPath = Join-Path $Dest 'docs/ROADMAP.md'
$roadmap = Get-Content -Raw -LiteralPath $roadmapPath
$roadmap = $roadmap.Replace('Milestone 0 – Foundation', $MilestoneName)
$roadmap = $roadmap.Replace('<commands run> + <results observed>', "$buildCommand (success), $testCommand (pass), $runCommand (smoke verified)")
Set-Content -LiteralPath $roadmapPath -Value $roadmap

$runtimePath = Join-Path $Dest 'docs/RUNTIME_VERIFICATION_REPORT.md'
$rr = Get-Content -Raw -LiteralPath $runtimePath
$rr = $rr.Replace('<build command>', $buildCommand)
$rr = $rr.Replace('<test command>', $testCommand)
$rr = $rr.Replace('<run command>', $runCommand)
Set-Content -LiteralPath $runtimePath -Value $rr

$changelogPath = Join-Path $Dest 'CHANGELOG.md'
$changelog = Get-Content -Raw -LiteralPath $changelogPath
$changelog = $changelog -replace '## \[Unreleased\]\s*', "## [Unreleased]`n`n### Added`n- Initialized Structured Mode governance baseline.`n`n"
Set-Content -LiteralPath $changelogPath -Value $changelog

Validate-Generated -root $Dest -requiresMigration:$requiresMigration

Remove-Item -LiteralPath (Join-Path $Dest 'project_init_templates') -Recurse -Force

$sessionPath = "exports/${dateStamp}_HANDOFF_SESSION_${IdeaId}.md"
@"
# Handoff Session

- Date: $dateStamp
- Idea ID: $IdeaId
- Export: `$exportPath`
- Prefill: `$prefillPath`
- Destination: `$Dest`
- Initialization: completed

The project has been successfully initialized under Structured Mode governance.
"@ | Set-Content -LiteralPath $sessionPath

Write-Host "Handoff prefill: $prefillPath"
Write-Host "Handoff session log: $sessionPath"
Write-Host 'The project has been successfully initialized under Structured Mode governance.'
