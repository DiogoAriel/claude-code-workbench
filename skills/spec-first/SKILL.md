---
name: spec-first
description: Turn an informal request into a short written plan (files, invariants, tests, rollout) and get approval before changing code. Use for any change bigger than a one-line fix, and whenever the request is ambiguous.
---

# Spec first

The plan is cheaper to correct than the code. Write it, show it, wait for the go-ahead.

## The plan has five parts, in this order

1. **Goal in one sentence.** What will be true when this is done.
2. **Files.** Which files are created or changed, one line each with the reason.
3. **Invariants.** The rules the change must respect or introduce (money never changes without an
   entry; a request with a known key never posts twice; a webhook with any failed check is rejected).
4. **Tests.** Which tests will prove it: unit for rules, integration for anything visible over an
   interface, and the failure-path tests that assert nothing happened.
5. **Rollout and risk.** Migrations, configuration, feature flags, what can break and how to roll back.

Keep it under forty lines. If it does not fit, the change is too big: split it.

## Decisions

List the decisions the human must take, at most four, each with a recommended option first and the
trade-off in one line. Everything else is decided in the plan and stated as such.

## After approval

- Create or update `_local/history/<today>.md` with the plan.
- Implement in the order of the plan. If reality disagrees with the plan, stop and say which line
  changed and why, then continue.
- Finish with the adversarial-review skill and the pasted test summary.
