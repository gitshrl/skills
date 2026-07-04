# skills

My [Claude Code](https://docs.claude.com/en/docs/claude-code) agent skills — a connected base suite that applies to any project, plus the engineering guidelines and plugins I run.

## Quick start (fresh machine)

One command sets up everything — all skills → `~/.claude/skills/`, `CLAUDE.md` + `RTK.md` → `~/.claude/`, [rtk](https://github.com/rtk-ai/rtk) installed + hooked, and all plugins/marketplaces:

```bash
curl -fsSL https://raw.githubusercontent.com/gitshrl/skills/main/install.sh | bash
```

Or from a clone: `git clone https://github.com/gitshrl/skills && ./skills/install.sh`

Idempotent — re-run any time to update (existing `CLAUDE.md`/`RTK.md` are backed up). Restart Claude Code afterwards. Needs `git`, `curl`, and the `claude` CLI; rtk requires nothing extra (prebuilt binary).

## Base suite

The skills in `base/` are connected and project-agnostic. One story, end to end:

1. **challenge** — stress-test a plan or design until every branch of the decision tree is resolved
2. **domain-model** — challenge a plan against the project's language; keeps `CONTEXT.md` and `docs/adr/` honest as decisions crystallise
3. **prototype** — throwaway code that answers the design questions talking can't
4. **architecture** — find deepening opportunities: shallow modules to consolidate, seams to strengthen
5. **handoff** — compact the session into a document the next session picks up

Under them sits one primitive: **core-interview**, the relentless one-question-at-a-time loop that `challenge`, `domain-model`, and `architecture` all delegate to. Tune the loop in one file; every consumer follows.

`core-*` skills are internal support — other skills trigger them; you don't invoke them directly.

## Stack skills

`stacks/` holds standalone skills scoped to a stack (python, rust, ai, backend). Each is independent — installed the same way, invoked only where its stack applies.

## Guidelines

[`CLAUDE.md`](./CLAUDE.md) — the engineering standards I drop into `~/.claude/CLAUDE.md`.

## Plugins

Plugins I run alongside these skills — install via Claude Code:

```
/plugin marketplace add anthropics/claude-plugins-official
/plugin marketplace add DietrichGebert/ponytail

/plugin install superpowers@claude-plugins-official
/plugin install rust-analyzer-lsp@claude-plugins-official
/plugin install ponytail@ponytail
```
