---
name: spawn
description: Spawn a full Claude session in a tmux window to work a task, or hand this conversation to one.
disable-model-invocation: true
argument-hint: "What should the spawned session work on?"
---

Spawn a separate full Claude Code session in a tmux window, never a subagent. The work gets its own context window, its own tools, and a pane the user can join.

1. Write the briefing to `docs/spawn/<slug>.md`:
   - With arguments: brief that task. Without arguments: hand this conversation off, then stop working the task here; two sessions on one task collide.
   - The session starts blank. Reference artifacts by path (specs, files, commits, issues), never "as discussed".
   - Name the skills the session should run, as slash commands. Do not restate what a skill already enforces; one line ("run `/debug` on it, `/verify` before done") replaces a paragraph.
   - Fence the collision zone: name the files and branches this session is using that the spawned one must not touch.
   - No secrets. Keys, tokens, and credentials never enter a briefing.
2. Spawn without stealing focus, from the project root:
   `tmux new-window -d -n <slug> -c <root> 'claude "$(cat docs/spawn/<slug>.md)"'`
   Outside tmux, wrap the same command in `tmux new-session -d -s <slug>` and tell the user to `tmux attach -t <slug>`.
3. Report the window name and one line on what it will do, then return to the current work. The spawned session is the user's to join, steer, or kill.

Working a draft spec (a `docs/specs/<slug>.md` that still has `## Open decisions`): offer one spawn per open, unblocked decision. Claim the decision in the spec before its session spawns; the briefing carries the spec path and the decision name, nothing the spec already says.
