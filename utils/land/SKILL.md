---
name: land
description: Finish a development branch. Use when implementation is complete and the work needs to be merged, pushed as a PR, kept, or discarded.
---

Nothing lands unverified.

1. Run the `verify` skill. Failing work does not reach the options menu.
2. Detect the environment: normal checkout, named-branch worktree, or detached HEAD (externally managed workspace).
3. Present exactly these options, no essay: merge locally to the base branch / push and open a PR / keep the branch as-is / discard. Detached HEAD drops the merge option. Discard requires the user to type "discard".
4. Merge path, in this order: from the main checkout merge the branch, re-run the tests on the merged result, remove the worktree, then delete the branch. Branch deletion before worktree removal fails; worktree removal from inside the worktree fails.
5. PR and keep paths preserve the worktree; the user needs it to iterate.

Rules:

- Never force-push.
- Never remove a worktree the harness created; only clean up ones under `.worktrees/` or `worktrees/`. Run `git worktree prune` after removal.
- Never merge without re-running tests on the merged result.
