# skills

Curated [Claude Code](https://docs.claude.com/en/docs/claude-code) agent skills, plus the engineering guidelines and plugins I run.

## Skills

Copy (or symlink) any folder into `~/.claude/skills/` and restart Claude Code.

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
