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

| Skill | Purpose | How to invoke | Invocation |
|---|---|---|---|
| **drill** | Stress-test a plan or design. A relentless one-question-at-a-time interview, each question with a recommended answer, until every branch of the decision tree is resolved. | `/drill`, or say "drill this plan" | model |
| **domain-model** | The same interview, but against the project's language. Calls out terms that conflict with the glossary, sharpens fuzzy ones, stress-tests relationships with concrete scenarios, and updates `CONTEXT.md`/ADRs inline as decisions crystallise. | `/domain-model` | user only |
| **prototype** | Throwaway code that answers a design question. Logic branch: a tiny terminal app to push a state machine or data model through hard cases. UI branch: several radically different variations on one route. The answer is the deliverable; the code gets deleted. | `/prototype`, or say "prototype this" | model |
| **implement** | Work a settled plan test-first, one thin slice at a time: failing test, minimum code, refactor green. Routes bugs to `debug` and ends by running `verify`. | `/implement`, or say "build it" | model |
| **debug** | Root-cause a bug before fixing it: reproduce, trace to first cause, verify one hypothesis with evidence, fix, add the regression test. | `/debug`, or just report a bug | model |
| **verify** | Prove a claim of done, fixed, or passing by running the commands and reading the output before making it. | `/verify`, fires before completion claims | model |
| **architecture** | Scan the codebase for deepening opportunities: shallow modules to consolidate, seams to strengthen. Presents candidates, interviews you through the one you pick, and can fan out sub-agents to design rival interfaces for it. | `/architecture` | model |
| **core-interview** | Internal support: the interview loop `drill`, `domain-model`, and `architecture` delegate to. Other skills trigger it; you don't invoke it directly. | none | model, only via other skills |

How they connect:

```mermaid
flowchart TD
    fresh([fresh project]) --> drill
    existing([existing codebase]) --> architecture

    drill --> dm[domain-model]
    dm --> proto[prototype]
    proto --> impl[implement]
    architecture -- contested interface --> proto

    impl -- bug appears --> debug
    debug --> impl
    impl --> verify
    verify --> done([done])

    drill -. delegates .-> ci[core-interview]
    dm -. delegates .-> ci
    architecture -. delegates .-> ci

    dm -- writes --> docs[("CONTEXT.md + docs/adr/")]
    architecture -- reads and writes --> docs
    proto -- verdict as ADR --> docs

    done -. session runs long .-> handoff[handoff]
```

## Utilities

Skills in `utils/` support any session without being a workflow step:

| Skill | Purpose | How to invoke | Invocation |
|---|---|---|---|
| **handoff** | Compact the session into a document the next session picks up. Pass an argument describing what the next session is for. | `/handoff "review the auth refactor"` | model |
| **research** | Spin up a background agent that investigates a question against primary sources (official docs, source code, specs) and writes the findings to a cited markdown file in the repo. | `/research`, or say "research X" | model |
| **teach** | A learning workspace: lessons, a mission, a glossary, and learning records that track what you actually understand across sessions. | `/teach` | user only |
| **worktree** | Isolated workspace before feature work: detect existing isolation, prefer the harness's native tool, fall back to git worktree under `.worktrees/`, verify a clean test baseline. | `/worktree` | model |
| **land** | Finish a branch: verify first, then merge, PR, keep, or discard, with worktree cleanup in the right order. | `/land` | model |
| **parallel** | One subagent per independent problem, all dispatched concurrently, integrated with a full-suite check. | `/parallel` | model |
| **delegate** | Execute a settled plan with a fresh subagent per task, a review after each, and a whole-branch review at the end. | `/delegate` | model |
| **write-skill** | Create or edit a skill test-first: record the failure without it, write the minimum that fixes it, close loopholes. | `/write-skill` | model |

## The documents the suite maintains

Two artifacts live in your project and connect the skills across sessions:

- **`CONTEXT.md`**: the domain glossary, and nothing else. Terms meaningful to domain experts, free of implementation details. `domain-model` writes it as terms get resolved; `architecture` reads it so refactoring candidates speak your domain language. Repos with multiple bounded contexts use a root `CONTEXT-MAP.md` pointing to per-context `CONTEXT.md` files. Format: [`base/domain-model/CONTEXT-FORMAT.md`](./base/domain-model/CONTEXT-FORMAT.md).
- **`docs/adr/`**: architectural decision records. Written sparingly, only when a decision is hard to reverse, surprising without context, and the result of a real trade-off. `domain-model` and `architecture` offer them at the right moments; `architecture` treats existing ADRs as decisions not to re-litigate; `prototype` captures its verdict as an ADR when it passes the same test. Format: [`base/domain-model/ADR-FORMAT.md`](./base/domain-model/ADR-FORMAT.md).

Both are created lazily, with no setup step. The first resolved term creates `CONTEXT.md`; the first decision worth recording creates `docs/adr/`. Skills that read them proceed silently when they're absent.

## From a fresh project

1. **`/drill`** the initial plan: walk the decision tree before any code exists.
2. **`/domain-model`** once the plan has domain words in it: pin the vocabulary; `CONTEXT.md` is born from the first resolved term.
3. **`/prototype`** whichever design question survived both interviews still contested: a state model that "feels wrong" or a UI you can't picture. Keep the answer, delete the code.
4. **`/implement`** the plan test-first, one thin slice at a time. A bug mid-slice routes to `/debug`; `/verify` proves the claim before anything is called done.
5. **`/handoff`** when the session runs long. The next session starts where this one stopped.

## In an existing codebase

1. **`/architecture`**: it explores the code (and `CONTEXT.md`/ADRs if present), then presents deepening candidates. Pick one; the interview walks constraints, dependencies, the shape of the deepened module, and what tests survive. Contested interface choices route to `/prototype`; resolved terms and rejected candidates land in `CONTEXT.md` and ADRs.
2. **`/drill`** any change plan before implementing it, same discipline as greenfield.
3. **`/domain-model`** when a plan touches domain concepts the glossary doesn't cover. The codebase is cross-referenced against what you say, and contradictions surface immediately.
4. **`/handoff`** to bridge sessions, same as greenfield.

## When to use what

| Moment | Skill |
|---|---|
| New plan, feature, or design | `drill` |
| Domain language needs settling | `domain-model` |
| Design question talking can't answer | `prototype` |
| Implementing a settled plan | `implement` |
| Bug or unexpected behavior | `debug` |
| About to claim done, fixed, or passing | `verify` |
| Existing code fights you | `architecture` |
| Reading legwork | `research` |
| Work needs isolation from the checkout | `worktree` |
| Branch done, needs merging or a PR | `land` |
| Independent failures or tasks, two or more | `parallel` |
| Multi-task plan to execute hands-off | `delegate` |
| Authoring or editing a skill | `write-skill` |
| Learning a topic across sessions | `teach` |
| Session runs long | `handoff` |

## Guidelines

[`CLAUDE.md`](./CLAUDE.md) is the agent's main instruction set, installed to `~/.claude/CLAUDE.md`.

## Plugins

Plugins I run alongside these skills. Install via Claude Code:

```
/plugin marketplace add anthropics/claude-plugins-official

# rust-analyzer language server: diagnostics, go-to-definition, type info.
# Stack-specific: activates only in Rust projects.
/plugin install rust-analyzer-lsp@claude-plugins-official
```
