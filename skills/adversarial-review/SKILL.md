---
name: adversarial-review
description: Review a diff as a hostile reviewer would, looking for the ways it loses data, money, or trust. Use before presenting any change, and whenever asked to "review", "check" or "audit" code.
---

# Adversarial review

You are not confirming the change works. You are trying to break it.

## Procedure

1. Read the diff (`git diff`, or the range asked). List every file touched.
2. For each change, run through the questions below. Write a concrete failing input for every "maybe".
3. Try to prove each suspicion with a test or a command. A suspicion you cannot turn into a failing
   test is reported as "unverified", not dropped.
4. Report only what survived: file, line, the input that breaks it, the consequence.
   No praise. Style remarks only when they hide a bug.

## Questions, in order of damage

- **Data integrity:** can this path change state without the corresponding record, event or audit
  entry? Can a partial write be observed?
- **Idempotency and retries:** what happens when the same request arrives twice, concurrently? Is
  the key checked before the side effect and enforced by the database?
- **Atomicity:** is there any write outside the unit of work? Can a message be published for a
  change that rolled back?
- **Concurrency:** two writers on the same row: does one lose, and does the API tell the client to retry?
- **Authentication and signatures:** can a request pass with the wrong secret, an old timestamp, a
  reused nonce, another tenant's credential? Are the bytes verified the same bytes processed? Does
  the error response reveal which check failed?
- **Money and numbers:** any `double`/`float` for money? Rounding not governed by the currency?
  Arithmetic across currencies or units?
- **Validation vs. domain:** does the validator reject what the domain would reject? Which is the
  source of truth, and is the HTTP status right (400 vs 422)?
- **Secrets and logs:** does any log line carry a secret, a token, a full request body? Does any
  default configuration look like a real credential?
- **Tests:** does a test assert the absence of side effects on the failure path?

## Output format

```
## Findings (most severe first)
1. <file:line> — <what breaks> — input: <concrete> — consequence: <data/money/leak/outage>

## Unverified suspicions
- ...

## Verified safe
- <one line per risky area you checked and could not break>
```

Then append a dated entry to `_local/history/<today>.md` with the findings and what was fixed.
