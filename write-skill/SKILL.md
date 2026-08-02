---
name: write-skill
description: Create or edit a skill and prove it changes behavior. Use when writing a new skill, editing an existing one, or verifying a skill before it ships.
---

Writing a skill is test-first development applied to prose.

1. Baseline first: run the scenario the skill targets on an agent WITHOUT the skill, and record exactly how it fails or rationalizes. No observed failure means the skill has nothing to teach.
2. Write the minimum skill that fixes those specific failures. Not a manual: the shortest process that changes the behavior.
3. Re-run the scenario with the skill loaded. It passes or the skill is wrong.
4. Close loopholes: new rationalizations found on re-runs get plugged, then verified again.

A test harness changes mechanics, not the loop: when one exists, automate the baseline re-run.

Conventions for this repo:

- Frontmatter carries `name` (letters, digits, hyphens) and `description`. The description states when to fire, with trigger phrasing ("Use when..."), not a summary of the process.
- `disable-model-invocation: true` only for skills that must never fire on their own; the description then reads as a human-facing one-liner.
- Keep SKILL.md lean. Separate files only for heavy reference or reusable assets; link them relatively.
- No em dashes. Decisive present tense. Zero upstream or status mentions.

Do not write a skill for one-off solutions, standard practice already well documented, or anything a linter or hook could enforce mechanically.
