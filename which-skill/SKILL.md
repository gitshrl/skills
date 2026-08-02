---
name: which-skill
description: Route me to the right skill when I don't know which one fits.
disable-model-invocation: true
---

The user does not know which skill fits their situation. Find the one that does.

1. Read the frontmatter (name and description) of every skill in `~/.claude/skills/*/SKILL.md`. Skills marked `disable-model-invocation: true` are hidden from your session registry, so the files are the source of truth, never your visible skill list.
2. If the situation is ambiguous between skills, ask one clarifying question. Otherwise ask nothing.
3. Answer with one skill, or a short ordered chain when the situation spans stages. Name the trigger (slash command or phrase). No menus.

When a chain is needed, the workflow order is: drill (fuzzy plan) → domain-model (terms worth pinning; user-only) → implement (settled plan; debug owns anything that breaks along the way) → verify (before claiming done) → architecture (existing code fights you). Session utilities sit outside the chain: research, teach (user-only), land, parallel, write-skill.

Never propose writing a new skill until step 1 has ruled out every existing one, including the hidden ones.
