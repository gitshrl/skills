---
name: deep
description: Full ceremony mode for the base workflow. Run /deep before risky or ambiguous work; /deep off returns to fast-first.
disable-model-invocation: true
---

DEEP MODE is now active for this session, until the user says "deep off", "fast", or the session ends.

While active, every base skill runs full ceremony, no fast paths, no model discretion:

- `drill` never routes past the interview and always writes the spec, whatever the task's apparent size.
- `core-interview` asks every branch one at a time and adopts zero assumptions; nothing is defaulted silently.
- `implement` works only from the spec, criterion by criterion.
- `land` presents the full options menu and re-runs tests on the merged result unconditionally, fast-forward or not.

If the user passed arguments, treat them as the work item and start immediately: run `drill` against it under deep mode.

Announce the mode change in one line. When the user turns it off, announce that too; fast-first with fork-surfacing resumes.
