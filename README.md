# skills

Curated [Claude Code](https://docs.claude.com/en/docs/claude-code) agent skills, plus the engineering guidelines and plugins I run.

## Quick start (fresh machine)

One command sets up everything — all skills → `~/.claude/skills/`, `CLAUDE.md` + `RTK.md` → `~/.claude/`, [rtk](https://github.com/rtk-ai/rtk) installed + hooked, and all plugins/marketplaces:

```bash
curl -fsSL https://raw.githubusercontent.com/gitshrl/skills/main/install.sh | bash
```

Or from a clone: `git clone https://github.com/gitshrl/skills && ./skills/install.sh`

Idempotent — re-run any time to update (existing `CLAUDE.md`/`RTK.md` are backed up). Restart Claude Code afterwards. Needs `git`, `curl`, and the `claude` CLI; rtk requires nothing extra (prebuilt binary).

## Skills

Copy (or symlink) any folder into `~/.claude/skills/` and restart Claude Code — or just run `install.sh` above.

## Guidelines

[`CLAUDE.md`](./CLAUDE.md) — the engineering standards I drop into `~/.claude/CLAUDE.md`.

## Plugins

Plugins I run alongside these skills — install via Claude Code:

```
/plugin marketplace add anthropics/claude-plugins-official
/plugin marketplace add forrestchang/andrej-karpathy-skills
/plugin marketplace add DietrichGebert/ponytail

/plugin install superpowers@claude-plugins-official
/plugin install rust-analyzer-lsp@claude-plugins-official
/plugin install andrej-karpathy-skills@karpathy-skills
/plugin install ponytail@ponytail
```
