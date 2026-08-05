---
name: land
description: Finish a development branch. Use when implementation is complete and the work needs to be merged, pushed as a PR, kept, or discarded.
---

Nothing lands unverified.

Fast path. When there is no spec, the diff is small, and the user already named the path in the invocation (merge, PR, keep, discard): skip the options menu and go. On the merge path, if the merge is a fast-forward, skip the post-merge test re-run; a fast-forward produces the exact tree `verify` just passed. Any divergence from the base branch voids this: diverged merge results are new trees and get the full re-run. The spec question is not part of the fast path: when a spec exists and its fate was not named in the invocation, ask it even here: one line, default keep. Deep mode (the `deep` skill is active) voids the whole fast path: full menu, unconditional re-run, and the spec question asked explicitly rather than inferred.

1. Run the `verify` skill. When a spec exists at `docs/specs/<slug>.md`, the final gate is a fresh subagent that reads only the spec and the diff and reports criterion by criterion, checking the diff against the repo's documented coding standards when they exist; the maker does not certify its own work. Failing work does not reach the options menu.
2. Detect the environment: normal checkout, named-branch worktree, or detached HEAD (externally managed workspace).
3. Present exactly these options, no essay: merge locally to the base branch / push and open a PR / keep the branch as-is / discard. Detached HEAD drops the merge option. Discard requires the user to type "discard".
4. On merge and PR paths, close the spec: route durable residue out (a decision worth keeping becomes an ADR, a settled term goes to `CONTEXT.md`, a change to the system's shape updates `ARCHITECTURE.md`). Then ask what happens to the spec file itself (keep it, or delete it) and say which is the default in the same breath: **keep unless the user asks otherwise**. Routing the residue is not optional and happens either way; only the file's fate is the user's call. A named path in the invocation ("land: merge, drop the spec") answers the question already: do not ask twice. Keep path leaves the spec in place without asking; it is still steering.
5. Write the PR body and the merge commit message from the spec: the goal as the summary line, acceptance criteria as the change list, non-goals as scope notes. The reasoning enters the permanent record where `git blame` points, whether or not the file survives.
6. Merge path, in this order: from the main checkout merge the branch, re-run the tests on the merged result, remove the worktree, then delete the branch. Branch deletion before worktree removal fails; worktree removal from inside the worktree fails.
7. PR and keep paths preserve the worktree; the user needs it to iterate.

Rules:

- Never force-push.
- Never delete a spec the user did not ask to delete. Silence is not consent; unanswered means keep.
- Never remove a worktree the harness created; only clean up ones under `.worktrees/` or `worktrees/`. Run `git worktree prune` after removal.
- Never merge without re-running tests on the merged result.
- Merge conflicts are resolved by intent, hunk by hunk, each side traced to its source; `--abort` is not a resolution.
