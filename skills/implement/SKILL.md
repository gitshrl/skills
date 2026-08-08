---
name: implement
description: "Implement a settled plan test-first, smallest slice at a time. Use when starting implementation of a feature or fix after the plan is settled, or when user says \"implement this\" or \"build it\"."
---

Work the plan one thin slice at a time. A slice is the smallest piece that changes observable behavior.

When a spec exists at `docs/specs/<slug>.md`, its acceptance criteria are the plan: work criterion by criterion, and let the spec's non-goals fence every diff. A spec that still carries an `## Open decisions` section is a draft, not a plan: stop and route back to `drill`; implementation cannot start until the draft is settled.

1. Pick the smallest unfinished slice of the plan.
2. Write the test that fails for it. Test external behavior through the interface, never implementation details. If no failing test can be written, the seam is wrong: stop and fix the plan, not the test.
3. Write the minimum code that makes it pass.
4. Refactor only with tests green. Match the existing style of the surrounding code.
5. Repeat until the plan has no unfinished slices.

Rules:

- On `main` or `development`, recommend a git branch before the first test and ask; the spec slug names it. Implementing on the base branch is the user's call to make, not yours to assume. A session already on a feature branch stays there.
- One implementation at a time. Unlanded work is never abandoned for a new task on your own: name the options (finish and land it, land it partial, or park it) and let the user pick. Only `land` ends the work.
- No production code before its failing test exists.
- A test that passes regardless of the change protects nothing; grep-style string checks counterfeit falsifiability.
- Keep every diff surgical: each changed line traces to the current slice.
- Each slice's commit message names the criterion it satisfies and the why, not only the what.
- A bug or unexpected failure mid-slice routes to the `debug` skill; do not patch around symptoms.
- Three failed attempts on the same slice stop the loop: escalate to the user with the criterion, what was tried, and the last error.
- When the last slice lands, run the `verify` skill before claiming the work is done.
- Deep mode (the `deep` skill is active): work only from the spec, criterion by criterion. No one-sentence plans.
