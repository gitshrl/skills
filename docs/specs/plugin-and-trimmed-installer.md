# plugin-and-trimmed-installer

## Goal
Ship pwguler/skills as a Claude Code plugin (plugin path for Claude Code) and trim install.sh to agents + instruction layer only, under the pwguler account.

## Non-goals
- No interactive selection menu in the installer; the two paths are the selection
- No npx skills CLI, no skills.sh service
- No plugin manifests for codex, cursor, or kimi
- No per-skill selective install
- No auto-cleanup of legacy `~/.claude/skills` copies; cleanup is manual, documented in the README
- No instruction layer (CLAUDE.md, RTK.md, rtk) inside the plugin; plugin ships skills only
- No opencode.jsonc handling in install.sh; the jq branch covers opencode.json only

## Acceptance criteria
- AC-1: `claude plugin validate . --strict` passes against the repo root
- AC-2: `.claude-plugin/plugin.json` ships exactly the 14 flat skill dirs at repo root
- AC-3: `package.json` version equals `plugin.json` version
- AC-4: install.sh has no reference to `~/.claude/skills` for skills install or pruning
- AC-5: install.sh still installs skills to `~/.agents/skills` with stale-skill pruning, and still deploys CLAUDE.md + RTK.md (backup first), the codex symlink, the opencode gating, and rtk + hook
- AC-6: REPO_URL in install.sh and every install URL in the README point at `github.com/pwguler/skills`
- AC-7: README documents the two paths (plugin vs script) with a pick-one warning and the manual cleanup command for legacy copies
- AC-8: the repo CLAUDE.md (and its AGENTS.md copy, if duplicated) carries the plugin validation and version-sync rules

## Verification
- `bash -n install.sh`
- `claude plugin validate . --strict`
- `jq -e '.skills | length == 14' .claude-plugin/plugin.json`
- `jq -e '.version' .claude-plugin/plugin.json` equals `jq -e '.version' package.json`
- `grep -c "claude/skills" install.sh` returns 0
- `grep -c "pwguler" install.sh README.md` returns 2 or more
- `./install.sh` re-runs idempotently on this machine
