---
name: land
description: Finish a development branch. Use when implementation is complete and the work needs to be merged, pushed as a PR, kept, or discarded.
---

Nothing lands unverified.

1. Run the `verify` skill. When a spec exists at `docs/specs/<slug>.md`, the final gate is a fresh subagent that reads only the spec and the diff and reports criterion by criterion; the maker does not certify its own work. Failing work does not reach the options menu.
2. Detect the environment: normal checkout, named-branch worktree, or detached HEAD (externally managed workspace).
3. Present exactly these options, no essay: merge locally to the base branch / push and open a PR / keep the branch as-is / discard. Detached HEAD drops the merge option. Discard requires the user to type "discard".
4. On merge and PR paths, close the spec first: route durable residue out (a decision worth keeping becomes an ADR, a settled term goes to `CONTEXT.md`, a change to the system's shape updates `ARCHITECTURE.md`), then commit the spec's deletion on the branch. The PR diff still shows the spec for reviewers; merged history stays clean. Keep path leaves the spec in place; it is still steering.
5. Write the PR body and the merge commit message from the spec: the goal as the summary line, acceptance criteria as the change list, non-goals as scope notes. The spec dies; its reasoning enters the permanent record where `git blame` points.
6. Merge path, in this order: from the main checkout merge the branch, re-run the tests on the merged result, remove the worktree, then delete the branch. Branch deletion before worktree removal fails; worktree removal from inside the worktree fails.
7. PR and keep paths preserve the worktree; the user needs it to iterate.

Rules:

- Never force-push.
- Never remove a worktree the harness created; only clean up ones under `.worktrees/` or `worktrees/`. Run `git worktree prune` after removal.
- Never merge without re-running tests on the merged result.
