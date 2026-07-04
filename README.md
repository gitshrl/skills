# skills

My [Claude Code](https://docs.claude.com/en/docs/claude-code) agent skills: a connected base suite that applies to any project, plus the engineering guidelines and plugins I run.

## Quick start (fresh machine)

One command sets up everything. All skills go to `~/.claude/skills/`, `CLAUDE.md` + `RTK.md` go to `~/.claude/`, [rtk](https://github.com/rtk-ai/rtk) is installed + hooked, and all plugins/marketplaces are added:

```bash
curl -fsSL https://raw.githubusercontent.com/gitshrl/skills/main/install.sh | bash
```

Or from a clone: `git clone https://github.com/gitshrl/skills && ./skills/install.sh`

Idempotent: re-run any time to update (existing `CLAUDE.md`/`RTK.md` are backed up). Restart Claude Code afterwards. Needs `git`, `curl`, and the `claude` CLI; rtk requires nothing extra (prebuilt binary).

## Base suite

The skills in `base/` are connected and project-agnostic.

| Skill | Purpose | How to invoke |
|---|---|---|
| **drill** | Stress-test a plan or design. A relentless one-question-at-a-time interview, each question with a recommended answer, until every branch of the decision tree is resolved. | `/drill`, or say "drill this plan" |
| **domain-model** | The same interview, but against the project's language. Calls out terms that conflict with the glossary, sharpens fuzzy ones, stress-tests relationships with concrete scenarios, and updates `CONTEXT.md`/ADRs inline as decisions crystallise. | `/domain-model` (user-invoked only) |
| **prototype** | Throwaway code that answers a design question. Logic branch: a tiny terminal app to push a state machine or data model through hard cases. UI branch: several radically different variations on one route. The answer is the deliverable; the code gets deleted. | `/prototype`, or say "prototype this" |
| **architecture** | Scan the codebase for deepening opportunities: shallow modules to consolidate, seams to strengthen. Presents candidates, interviews you through the one you pick, and can fan out sub-agents to design rival interfaces for it. | `/architecture` |
| **core-interview** | Internal support: the interview loop `drill`, `domain-model`, and `architecture` delegate to. Other skills trigger it; you don't invoke it directly. | none |

## Utilities

Skills in `utils/` support any session without being a workflow step:

| Skill | Purpose | How to invoke |
|---|---|---|
| **handoff** | Compact the session into a document the next session picks up. Pass an argument describing what the next session is for. | `/handoff "review the auth refactor"` |

## The documents the suite maintains

Two artifacts live in your project and connect the skills across sessions:

- **`CONTEXT.md`**: the domain glossary, and nothing else. Terms meaningful to domain experts, free of implementation details. `domain-model` writes it as terms get resolved; `architecture` reads it so refactoring candidates speak your domain language. Repos with multiple bounded contexts use a root `CONTEXT-MAP.md` pointing to per-context `CONTEXT.md` files. Format: [`base/domain-model/CONTEXT-FORMAT.md`](./base/domain-model/CONTEXT-FORMAT.md).
- **`docs/adr/`**: architectural decision records. Written sparingly, only when a decision is hard to reverse, surprising without context, and the result of a real trade-off. `domain-model` and `architecture` offer them at the right moments; `architecture` treats existing ADRs as decisions not to re-litigate; `prototype` captures its verdict as an ADR when it passes the same test. Format: [`base/domain-model/ADR-FORMAT.md`](./base/domain-model/ADR-FORMAT.md).

Both are created lazily, with no setup step. The first resolved term creates `CONTEXT.md`; the first decision worth recording creates `docs/adr/`. Skills that read them proceed silently when they're absent.

## From a fresh project

1. **`/drill`** the initial plan: walk the decision tree before any code exists.
2. **`/domain-model`** once the plan has domain words in it: pin the vocabulary; `CONTEXT.md` is born from the first resolved term.
3. **`/prototype`** whichever design question survived both interviews still contested: a state model that "feels wrong" or a UI you can't picture. Keep the answer, delete the code.
4. Build.
5. **`/handoff`** when the session runs long. The next session starts where this one stopped.

## In an existing codebase

1. **`/architecture`**: it explores the code (and `CONTEXT.md`/ADRs if present), then presents deepening candidates. Pick one; the interview walks constraints, dependencies, the shape of the deepened module, and what tests survive. Contested interface choices route to `/prototype`; resolved terms and rejected candidates land in `CONTEXT.md` and ADRs.
2. **`/drill`** any change plan before implementing it, same discipline as greenfield.
3. **`/domain-model`** when a plan touches domain concepts the glossary doesn't cover. The codebase is cross-referenced against what you say, and contradictions surface immediately.
4. **`/handoff`** to bridge sessions, same as greenfield.

## Guidelines

[`CLAUDE.md`](./CLAUDE.md) is the agent's main instruction set, installed to `~/.claude/CLAUDE.md` so it governs every session: voice, engineering bar, surgical changes, git rules, and how skills are used. Skills define workflows; `CLAUDE.md` defines behavior. When they overlap, `CLAUDE.md` wins.

## Plugins

Plugins I run alongside these skills. Install via Claude Code:

```
/plugin marketplace add anthropics/claude-plugins-official
/plugin marketplace add DietrichGebert/ponytail

/plugin install superpowers@claude-plugins-official
/plugin install rust-analyzer-lsp@claude-plugins-official
/plugin install ponytail@ponytail
```
