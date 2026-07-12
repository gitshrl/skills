---
name: debug
description: Find the root cause of a bug before fixing it. Use when a bug, test failure, or unexpected behavior appears, before proposing any fix.
---

No fix before root cause. Symptoms are where the search starts, never where it ends.

Fast path: when the first cause is directly visible in the error output (the stack line points at it), skip the hypothesis loop but never the reproduction or the regression test. If the visible fix does not make the reproduction pass on the first try, the cause was not visible: run the full discipline. Deep mode (the `deep` skill is active): full discipline always.

1. Reproduce first. Build the smallest deterministic reproduction. If it cannot be reproduced, gather evidence (logs, inputs, versions) until it can; do not guess.
2. Read the actual error and trace it back to the first cause in the chain, not the nearest symptom.
3. Form one hypothesis. State it. Verify it with evidence (a log line, a probe, an inspection) before touching any code.
4. Fix the root cause. One fix at a time; if two hypotheses compete, test the cheaper one first.
5. Add the regression test that would have caught this: red on the old code, green on the fix.
6. Run the `verify` skill before claiming it is fixed.

Rules:

- No shotgun fixes, no "try this and see if it helps".
- If the fix does not make the reproduction pass, the hypothesis was wrong: return to step 3, do not stack a second fix on top.
- If the root cause reveals a design problem, say so and offer the `architecture` skill instead of burying a workaround.
