---
name: delegate
description: Execute a settled multi-task plan by dispatching a fresh subagent per task with a review after each. Use when a plan's tasks are mostly independent and should run in this session without stopping between tasks.
---

Fresh subagent per task, review after each, broad review at the end.

When a spec exists at `docs/specs/<slug>.md`, it is the plan: one task per acceptance criterion, and reviewers check against the spec's criteria and non-goals, not the task text alone.

Pre-flight: scan the whole plan once for tasks that contradict each other or its stated constraints. Raise everything found as one batched question before task 1, not one interrupt per discovery.

Per task:

1. Dispatch a fresh implementer subagent with the task text and exactly the context it needs, nothing inherited from the session. It implements under the `implement` skill's discipline (test-first, thin slices), commits, and self-reviews. Invoking `delegate` is the ask for that commit.
2. Dispatch a reviewer subagent against the task's diff: spec compliance and code quality. Critical or important findings go to a fix subagent, then re-review. Fast default: mechanical, well-specified tasks may share one batched review per phase; judgment tasks keep a reviewer each. Deep mode (the `deep` skill is active): one reviewer per task, no batching.
3. Mark the task complete and move on. No check-ins between tasks; stop only for a blocker, genuine ambiguity, or completion.

Model choice per role: the cheapest model that handles the task. Mechanical, well-specified tasks go to a fast model; integration and judgment to a standard one; the final whole-branch review to the most capable one. State the model explicitly on every dispatch.

When all tasks are done: dispatch the final whole-branch review, then run the `land` skill.
