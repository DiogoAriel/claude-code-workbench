---
name: incident-analysis
description: Structured root-cause analysis for a production incident, a flaky test or an unexplained failure. Use when asked to "investigate", "find the root cause", "why did this fail", or when a failure cannot be explained in one sentence.
---

# Incident analysis

Measure before changing. A fix without a reproduced cause is a guess, and guesses in production
cost more than the incident.

## Steps

1. **State the symptom precisely.** What was observed, where (log line, test name, HTTP status,
   metric), when, how often. Quote the exact message.
2. **Reproduce.** The smallest test, script or request that shows the failure. If it cannot be
   reproduced, stop at "hypotheses" and say so.
3. **Instrument.** Logs, counters, timers or assertions around the suspected area. Run again.
   Collect numbers, not impressions.
4. **Narrow.** One variable at a time: by commit (`git bisect`), by layer (edge → handler → domain
   → storage → network), by input.
5. **Name the cause.** One sentence: "X happens because Y". Two candidates means keep measuring.
6. **Fix and prove.** The reproduction now passes and the full suite stays green.
7. **Prevent.** Add the test that would have caught it. If the cause was a missing invariant, move
   the invariant into the domain so it cannot be bypassed.

## Record

Append to `_local/history/<today>.md`:

```
## Incident: <short title>
- Symptom:
- Reproduction:
- Measurements (before):
- Root cause:
- Fix:
- Measurements (after):
- Prevention (test / invariant added):
```

If the incident changed a design decision, add an ADR in `docs/adr/`.

## Examples of real causes found this way

- Multicast channels going silent above a group count: router control messages exceeding the VLAN
  MTU, found by capturing packets, not by reading code.
- Messages dropped at market open: a single drop-oldest queue; fixed with separate lanes, verified
  by counting drops per lane before and after.
- Gateway timeouts: an ingress limit of 60 s against calls averaging over 100 s, visible only after
  adding a duration histogram.
