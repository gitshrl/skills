---
name: parallel
description: Dispatch independent tasks to concurrent subagents. Use when two or more failures or tasks are independent, sharing no files or state, and can be worked simultaneously.
---

One agent per independent problem domain, all dispatched in a single response so they run concurrently.

Each agent's prompt carries:

- Scope: one file, one subsystem, one problem. "Fix all the tests" loses the agent.
- Context, pasted in: error messages, test names, relevant paths. Agents inherit nothing from the session.
- Constraints: what must not change ("tests only", "do not touch production code").
- Expected return: a summary of root cause and changes, so integration is reviewable.

Integrate when they return: read each summary, check the diffs for conflicts, run the full suite, then the `verify` skill before claiming the batch done.

Do not use when failures are related (fixing one may fix the rest: investigate together first), when the problem is still exploratory, or when agents would touch the same files.
