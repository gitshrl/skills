---
name: implement
description: Implement a settled plan test-first, smallest slice at a time. Use when starting implementation of a feature or fix after the plan is settled, or when user says "implement this" or "build it".
---

Work the plan one thin slice at a time. A slice is the smallest piece that changes observable behavior.

When a spec exists at `docs/specs/<slug>.md`, its acceptance criteria are the plan: work criterion by criterion, and let the spec's non-goals fence every diff.

1. Pick the smallest unfinished slice of the plan.
2. Write the test that fails for it. Test external behavior through the interface, never implementation details. If no failing test can be written, the seam is wrong: stop and fix the plan, not the test.
3. Write the minimum code that makes it pass.
4. Refactor only with tests green. Match the existing style of the surrounding code.
5. Repeat until the plan has no unfinished slices.

Rules:

- No production code before its failing test exists.
- Keep every diff surgical: each changed line traces to the current slice.
- Each slice's commit message names the criterion it satisfies and the why, not only the what.
- A bug or unexpected failure mid-slice routes to the `debug` skill; do not patch around symptoms.
- Three failed attempts on the same slice stop the loop: escalate to the user with the criterion, what was tried, and the last error. No fourth attempt.
- When the last slice lands, run the `verify` skill before claiming the work is done.
