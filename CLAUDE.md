# Working agreement

This file is installed as `~/.claude/CLAUDE.md`. It applies to every project unless a project's own
`CLAUDE.md` says otherwise. Read it before the first action of a session.

## Who you are working with

Tech lead and senior software engineer, 20 years in banking, fintech, healthcare and industrial
systems. Main stacks: C# / .NET, Java (Spring), PHP (Laravel), TypeScript. Cloud on AWS and Azure,
Kubernetes, Terraform, GitLab CI and GitHub Actions. Runs an independent software practice and
works for regulated clients, so confidentiality is a hard rule, not a preference.

Works in Portuguese (pt-BR). Technical terms stay in English. Answer in Portuguese unless the
repository's documentation is in English, in which case code, comments and docs are in English
and the conversation stays in Portuguese.

## How work is requested

- A short description of the goal, often informal. Turn it into a plan with the files, the
  invariants and the tests, show it, and wait for "pode resolver" (or equivalent) before changing
  anything bigger than a one-line fix.
- Questions come back as one list of decisions with a recommended option first. Never more than
  four. Everything that does not need a decision is decided and stated.
- Mid-task messages are corrections, not new tasks: adjust and keep going. A genuinely new topic
  gets a separate session.
- When something cannot be done on this machine (for example Docker does not run on the host),
  say so once, propose the nearest path, and continue with what can be done.

## Rules

1. **No tool attribution, anywhere.** Commit messages, pull request text, code comments, docs and
   file headers never mention the assistant, the model or AI. No `Co-Authored-By` trailers of any kind.
   The hook in `hooks/` enforces it for commits; the rule still applies to everything else.
2. **Journal in `_local/`.** Every repository keeps `_local/memory.md` (facts and decisions that
   stay true) and `_local/history/YYYY-MM-DD.md` (operations in order, with outcomes). `_local/` is
   git-ignored. Read it at the start of a session, append during, close with an outcome. See the
   `local-journal` skill.
3. **Never invent data.** No made-up numbers, metrics, dates, names or results. A gap is marked
   `⟦fill in⟧` and listed at the end for the human to complete.
4. **Confidentiality.** Public material (repositories, CVs, profiles, posts) never names clients,
   internal product names, real endpoints, secrets or data from an engagement. Describe the work
   generically ("a regulated payments company", "an exchange market data feed").
5. **Measure before changing.** For any bug, incident or performance claim: reproduce, instrument,
   read the numbers, then change. The `incident-analysis` skill is the procedure.
6. **Proof, not opinion.** "It works" means build and tests ran and the summary is pasted. A diff
   is reviewed adversarially (`adversarial-review` skill) before it is presented.
7. **Spec first for anything non-trivial.** Files, invariants, tests, rollout. Approval, then code.
8. **Direct answers.** Lead with the outcome. Short sentences. No praise, no hedging, no summaries
   of what was just said. Flag risks in one line each.
9. **Clean code, explained.** Small cohesive units, explicit names, no clever tricks. Every design
   decision that is not obvious gets a comment at the point of decision and, if it shapes the
   system, an ADR in `docs/adr/`.

## Defaults by stack

- **.NET:** .NET 8 LTS or newer, central package management, warnings as errors, analyzers at
  `latest-recommended`, NuGet audit failing on known vulnerabilities, minimal APIs, xUnit +
  FluentAssertions 7.x, FluentValidation, EF Core with a persistence model separate from the domain,
  Serilog + OpenTelemetry. Domain project has no framework references. See `dotnet-bootstrap` skill.
- **Pipelines:** gitleaks, semgrep, trivy (fs + image), checkov, SBOM (CycloneDX). Findings fail
  the build. See `devsecops-pipeline` skill.
- **Git:** conventional commits in imperative mood; one logical change per commit; `main` always
  green; branch per change. See `git-hygiene` skill.

## What not to do

- Do not run destructive commands (`git push --force`, `terraform apply/destroy`, deletes) without
  an explicit, specific go-ahead in the conversation.
- Do not touch public profiles, repositories or publish anything on the human's behalf without the
  same explicit go-ahead.
- Do not paraphrase error messages; quote them.
- Do not end a turn with a question that the plan could have answered.
