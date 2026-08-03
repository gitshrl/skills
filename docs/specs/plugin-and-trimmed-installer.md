# plugin-and-trimmed-installer

## Goal
Ship pwguler/skills for Claude Code only: a plugin marketplace as the primary path, a `npx skills` path for editable copies, and no installer script.

## Non-goals
- No installer script (install.sh is deleted)
- No opencode, codex, or other non-Claude harness targets
- No interactive selection menu; the two Claude paths are the selection
- No per-skill selective install; the suite ships as a whole loop
- No instruction layer (CLAUDE.md, RTK.md, rtk) inside the plugin or the npx skills bundle; those extras stay manual, documented in the README

## Acceptance criteria
- AC-1: `claude plugin validate . --strict` passes against the repo root
- AC-2: `.claude-plugin/plugin.json` ships exactly the 14 skill dirs under `skills/`
- AC-3: `package.json` version equals `plugin.json` version
- AC-4: install.sh is absent from the repo
- AC-5: `npx skills add pwguler/skills` discovers exactly the 14 skill dirs under `skills/` (container dir walked one level deep)
- AC-6: README documents both paths (plugin vs npx skills) with a pick-one warning and the manual instruction-layer step
- AC-7: the repo CLAUDE.md (and its AGENTS.md hardlink copy) carries the plugin validation and version-sync rules

## Verification
- `claude plugin validate . --strict`
- `git ls-files | grep -c install.sh` returns 0
- `jq -e '.skills | length == 14' .claude-plugin/plugin.json`
- `jq -e '.version' .claude-plugin/plugin.json` equals `jq -e '.version' package.json`
- `npx skills add pwguler/skills` in a temp directory installs 14 skills
- `grep -c "npx skills" README.md` returns 1 or more
