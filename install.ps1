# Installs the working agreement, skills, agents, hook and settings into ~/.claude (Windows).
# Existing files are backed up with a timestamp before being replaced. Run from the repository root.
$ErrorActionPreference = 'Stop'

$source = $PSScriptRoot
$target = Join-Path $HOME '.claude'
$stamp  = Get-Date -Format 'yyyyMMdd-HHmmss'

function Install-Item([string]$from, [string]$to) {
    if (Test-Path $to) {
        $backup = "$to.bak-$stamp"
        Move-Item -Path $to -Destination $backup -Force
        Write-Host "backed up $to -> $backup"
    }
    $parent = Split-Path $to -Parent
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    Copy-Item -Path $from -Destination $to -Recurse -Force
    Write-Host "installed $to"
}

Install-Item (Join-Path $source 'CLAUDE.md')               (Join-Path $target 'CLAUDE.md')
Install-Item (Join-Path $source 'settings.template.json')  (Join-Path $target 'settings.json')
Install-Item (Join-Path $source 'hooks')                   (Join-Path $target 'hooks')

foreach ($skill in Get-ChildItem (Join-Path $source 'skills') -Directory) {
    Install-Item $skill.FullName (Join-Path $target "skills\$($skill.Name)")
}
foreach ($agent in Get-ChildItem (Join-Path $source 'agents') -File) {
    Install-Item $agent.FullName (Join-Path $target "agents\$($agent.Name)")
}

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Warning 'node was not found on PATH; the no-ai-attribution hook needs Node.js to run.'
}

Write-Host "`nDone. Open a new session for the settings and hook to take effect."
