---
name: worktree
description: Set up an isolated workspace before feature work. Use when starting work that should not touch the current checkout, or before executing an implementation plan.
---

Isolation first, native tools first.

1. Detect existing isolation. If `git rev-parse --git-dir` and `--git-common-dir` resolve to different paths, you are already in a linked worktree: use it, create nothing. Guard against submodules first (`git rev-parse --show-superproject-working-tree` returning a path means submodule, treat as a normal repo).
2. Prefer the harness's native worktree tool (`EnterWorktree`, a `/worktree` command, a `--worktree` flag) over raw git. Raw `git worktree add` beside a native tool creates state the harness cannot see.
3. Fallback, only without a native tool: `git worktree add .worktrees/<branch> -b <branch>`. Verify the directory is gitignored before creating (`git check-ignore -q .worktrees`); if not, add it to `.gitignore` and commit that first.
4. Run the project's setup (install dependencies) and its test suite. Report the baseline. A failing baseline stops the work: ask whether to proceed or investigate, since new bugs become indistinguishable from old ones.

Rules:

- Never create a worktree inside an existing one.
- Ask consent before creating a worktree unless the user's instructions already declare a preference.
- Explicit user preference beats existing directories beats the default location.
