---
name: deep
description: Full ceremony mode for the whole suite. Run /deep before risky or ambiguous work; /deep off returns to fast-first.
disable-model-invocation: true
---

DEEP MODE is now active for this session, until the user says "deep off", "fast", or the session ends. Announce activation in one line. Announce deactivation too; fast-first then resumes. If the user passed arguments, treat them as the work item and start immediately: run `drill` against it under deep mode.

Fast-first is the default everywhere: each skill runs the leanest version that keeps its guarantees. Deep mode removes the leanness, not the guarantees.

Each skill under the dial carries its own deep behavior in its `SKILL.md`, on the line naming this skill. Before running any of them, load that skill's deep line and apply the behavior it names. The suite: drill, core-interview (and everything built on it), implement, debug, verify, architecture, land.

What deep never changes: verification stays evidence-based in both modes, attempt caps and escalation stay armed, non-goals stay enforced, and forks are surfaced, never guessed. Deep buys thoroughness, not a different standard of truth.
