---
name: git-hygiene
description: How commits, branches and pull requests are written in this person's repositories. Use before any git commit, push or PR, and when asked to "commit", "push" or "open a PR".
---

# Git hygiene

## Commit messages

- Conventional commits: `feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `chore:`, `perf:`, `ci:`.
- Subject in imperative mood, lower case after the prefix, no period, under 72 characters.
- Body only when the subject cannot carry the "why". Wrap at 72.
- **No trailers.** No `Co-Authored-By`, no `Signed-off-by` unless the project requires DCO, and
  never any reference to an assistant, a model, "AI" or a tool that wrote the code. The
  `no-ai-attribution` hook rejects such messages; do not work around it.

## What goes in a commit

- One logical change. Formatting-only changes are their own `chore:` commit.
- Build and tests pass at every commit on `main`.
- Never commit `_local/`, `.env`, local databases, generated secrets or `bin/`/`obj/`.
  gitleaks runs in CI and will fail the pipeline.

## Branches and pull requests

- Branch per change, named `type/short-description` (`feat/webhook-replay-guard`).
- PR description: what and why, how it was tested (paste the summary), risks and rollback.
  Same attribution rule as commits.
- `git push --force` only on your own branch, only with an explicit go-ahead, never on `main`.

## Identity

Set the author per repository when it differs from the global config:

```bash
git config user.name  "Full Name"
git config user.email "verified-on-github@example.com"
```

The e-mail must be verified on the hosting platform, or contributions are not credited.

## Line endings

Add a `.gitattributes` on day one so Windows and Linux contributors do not fight over CRLF:

```
* text=auto eol=lf
*.sln text eol=crlf
*.png binary
```
