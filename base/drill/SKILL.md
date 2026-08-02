---
name: drill
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, drill into their design, or says "drill this" or "drill me".
---

First, size the ask. If it has no real decision tree (one obvious change, a small diff, a criterion statable in one sentence), say so and route straight to `implement` with that sentence as the plan; a spec for an obvious change is ceremony. A genuine fork discovered mid-task is never guessed: stop, name it, let the user answer or switch to deep. If `verify` fails twice on a task judged obvious, the task was lying about its size: stop and drill it properly.

Deep mode (the `deep` skill is active): no sizing, no routing past the interview; the full session runs and the spec is always written.

Run the `core-interview` skill against the plan or design under discussion.

Shape of the session:

- Explore the project context before the first question. Questions the codebase, docs, or recent commits can answer are never asked.
- If the ask bundles several independent pieces, say so and drill the first piece; the rest queue up.
- Before settling a direction, put 2 or 3 genuinely different approaches on the table with trade-offs, leading with a recommendation.
- Cut ruthlessly: anything the stated constraints don't demand leaves the design.

The session ends when every branch of the decision tree is resolved: state the settled design in a short summary and get explicit agreement before any implementation starts.

When the settled design is implementation work, write the spec to `docs/specs/<slug>.md` in the target project using [SPEC-FORMAT.md](SPEC-FORMAT.md): goal, non-goals, checkable acceptance criteria, verification commands. The spec steers the loop: `implement` builds from it, `verify` gates against it, `land` closes it out and asks whether to keep or delete the file.

## The tree does not fit this session — write the draft

When the decision tree cannot resolve here — decisions await research beyond this context, or the tree is simply too large for one session — do not force a settled spec out of an unsettled design. Write the spec as a **draft** instead: `Destination`, `Decisions so far` (empty), `Open decisions`, `Not yet specified` (fog), `Out of scope`. Each open decision carries a Mode:

- **AFK** — a `/research` subagent can resolve it alone. Fire one subagent per AFK decision, in parallel, in this session.
- **HITL** — only a live exchange with the user resolves it. Never answer your own HITL question.

Writing the draft is one session's work: name the destination, sketch the frontier, write the draft, fire the AFK subagents, stop. It resolves nothing itself.

**Later sessions work the draft.** When a session opens a spec that still has an `## Open decisions` section:

1. Load the whole spec — the low-res view, not one decision's deep dive.
2. Pick the next open decision; if the user named one, use that. Claim it before working it.
3. Resolve it: AFK decisions read the findings the subagent left; HITL decisions are worked with the user, one question at a time, through the `core-interview` skill.
4. Record the resolution in `Decisions so far`, and remove the decision from `Open decisions`. Graduate anything now sharp from `Not yet specified` into fresh open decisions. A decision revealed to sit beyond the destination is ruled out of scope instead of resolved.
5. When the last open decision closes, delete the `## Open decisions` section — the spec is settled and the loop takes over.

One decision per session, except AFK decisions already dispatched. If no fog surfaces at all — the way is clear and the journey fits one session — there is no draft; settle normally.
