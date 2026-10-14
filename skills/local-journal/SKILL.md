---
name: local-journal
description: Keep a git-ignored _local folder with the project's memory and an operations history. Use at the start of every session in any repository, before the first change, and again when the work is done.
---

# Local journal

`_local/` is the working memory of a repository. It stays on the machine: add `_local/` to `.gitignore`
the first time you create it.

```
_local/
├── memory.md              # facts and decisions that stay true across sessions
└── history/
    └── YYYY-MM-DD.md      # what was done that day, in order, with outcomes
```

## At the start of a session

1. If `_local/` does not exist, create it and add `_local/` to `.gitignore`.
2. Read `_local/memory.md` and the newest file in `_local/history/`. Mention anything pending.
3. Create today's history file with a heading and the goal stated by the human.

## During the work

Append one line per operation that changed something: file edited, command run with its result,
decision taken and why. Short, factual, chronological. Record failures as well as successes; the
failed attempt is the part a later session needs most.

## At the end

1. Add an "Outcome" section: done, not done, verified (paste the build/test summary).
2. Promote anything that will still be true next week into `_local/memory.md`: environment facts,
   conventions, gotchas, open questions.

## Format

```
# 2026-10-14 — <goal>

- 14:02 build failed: NU1902 vulnerable package → bumped to 1.19.1
- 14:20 SQLite cannot ORDER BY DateTimeOffset → binary converter when IsSqlite()

## Outcome
- Done: ...
- Not done: ...
- Verified: 36 tests passed (24 unit, 12 integration)
```

`memory.md` is organised by sections: Environment, Conventions, Gotchas, Open questions. Keep each
entry to one or two lines; it is an index, not a diary.
