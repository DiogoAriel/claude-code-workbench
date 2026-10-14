# claude-code-workbench

The working agreement, skills, agents, hook and settings I install on every machine where I use
Claude Code. It encodes how I ask for engineering work and the rules the work has to follow: no
invented data, no client names in public material, a local journal in every repository, proof by
build and tests, adversarial review before anything is presented, and git history that reads as
human work.

Nothing here is specific to one project. Project rules live in each repository's own `CLAUDE.md`
(see [payments-ledger-platform](https://github.com/DiogoAriel/payments-ledger-platform) for an example).

## Contents

```
CLAUDE.md                 global working agreement, installed as ~/.claude/CLAUDE.md
settings.template.json    permissions (allow/deny) and the hook registration, installed as ~/.claude/settings.json
hooks/
  no-ai-attribution.js    PreToolUse hook: rejects commits/PRs that mention an assistant or carry Co-Authored-By trailers
skills/
  local-journal/          _local/memory.md + _local/history/YYYY-MM-DD.md in every repository
  spec-first/             five-part plan with at most four decisions, approval before code
  adversarial-review/     hostile review checklist ordered by damage; findings must be reproducible
  incident-analysis/      reproduce, instrument, narrow, name the cause, prevent
  git-hygiene/            conventional commits, no trailers, branch per change, .gitattributes
  dotnet-bootstrap/       solution layout and settings for .NET: central packages, warnings as errors, tests without Docker
  devsecops-pipeline/     gitleaks, semgrep, trivy, checkov, SBOM; findings fail the build
agents/
  reviewer.md             independent reviewer that runs the build and tests itself
  incident-analyst.md     root-cause investigator; causes, not fixes
  spec-writer.md          turns an informal request into the plan
templates/
  github-security.yml     security workflow (GitHub Actions)
  gitlab-ci.yml           equivalent pipeline for GitLab
install.ps1 / install.sh  copy everything into ~/.claude with timestamped backups
```

## Install

```powershell
git clone https://github.com/DiogoAriel/claude-code-workbench.git
cd claude-code-workbench
.\install.ps1          # Windows
```

```bash
./install.sh           # Linux / macOS
```

Open a new session afterwards. The hook needs Node.js on `PATH`.

## The rules, in short

| Rule | Why | Enforced by |
|---|---|---|
| No tool attribution in commits, PRs, comments or docs | the history is my work, and public profiles must read that way | `hooks/no-ai-attribution.js` + `git-hygiene` skill |
| `_local/` journal in every repository, git-ignored | a later session (or I) can pick up exactly where things stopped | `local-journal` skill |
| Never invent numbers, names or results | a made-up metric fails the first question in a review | `CLAUDE.md`, marked gaps `⟦fill in⟧` |
| No client names or real endpoints in public material | regulated clients, signed agreements | `CLAUDE.md` |
| Measure before changing | most "fixes" of unmeasured problems are guesses | `incident-analysis` skill |
| Build and tests pasted, not described | "it works" is not evidence | `CLAUDE.md`, `reviewer` agent |
| Plan and approval before non-trivial changes | correcting a plan is cheaper than correcting code | `spec-first` skill |

## How a typical task runs

1. I describe the goal in a sentence or two, in Portuguese.
2. `spec-first` produces the plan and the few decisions I need to take. I answer; usually "pode resolver".
3. The work starts by writing the plan into `_local/history/<today>.md`, then code, then build and tests.
4. `adversarial-review` runs on the diff; findings are fixed or reported as unverified.
5. The result comes back as: what changed, the pasted test summary, what was not done, risks in one line each.
6. Commits follow `git-hygiene`; the hook makes the attribution rule impossible to forget.

## Adapting it

Fork it and change `CLAUDE.md` first: the "Who you are working with" and "Defaults by stack"
sections are mine. The skills are stack-agnostic except `dotnet-bootstrap`; add one per stack you use.
The hook's forbidden patterns are at the top of `hooks/no-ai-attribution.js`.

## License

MIT.
