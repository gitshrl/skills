---
name: deep
description: Full ceremony mode for the whole suite. Run /deep before risky or ambiguous work; /deep off returns to fast-first.
disable-model-invocation: true
---

DEEP MODE is now active for this session, until the user says "deep off", "fast", or the session ends. Announce activation in one line. Announce deactivation too; fast-first then resumes. If the user passed arguments, treat them as the work item and start immediately: run `drill` against it under deep mode.

Fast-first is the default everywhere: each skill runs the leanest version that keeps its guarantees, and a genuine fork is never guessed, it is surfaced. Deep mode removes the leanness, not the guarantees. While active:

| Skill | Deep behavior |
|---|---|
| drill | No sizing. Never routes past the interview. The spec is always written, whatever the task's apparent size. |
| core-interview (and all skills built on it) | Every branch asked one at a time. Zero assumptions adopted. Question batching off. |
| domain-model | Full interview per above. The first-contact seeding pass is still offered, never auto-run; it writes to the user's project. |
| prototype | The exhaustive artifact: several radically different UI variations, or a logic app that pushes every hard case, not the minimal one that answers the question. |
| implement | Works only from the spec, criterion by criterion. No one-sentence plans. |
| debug | Full discipline always: reproduction, stated hypothesis, evidence, fix, regression test. The visible-cause shortcut is off. |
| verify | Exercise the changed path end to end unconditionally. Gate every criterion. A partial claim is not accepted as final. |
| architecture | Whole-codebase sweep, full candidate list, rival-interface sub-agents on the picked candidate. |
| delegate | One reviewer per task, no batched reviews. Final whole-branch review by the most capable model. |
| land | Full options menu regardless of named intent. Unconditional post-merge re-run, fast-forward or not. |

What deep never changes: verification stays evidence-based in both modes, attempt caps and escalation stay armed, non-goals stay enforced, and forks are surfaced, never guessed. Deep buys thoroughness, not a different standard of truth.
