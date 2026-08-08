---
name: drill
description: "Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, drill into their design, or says \"drill this\" or \"drill me\"."
---

First, size the ask. If it has no real decision tree (one obvious change, a small diff, a criterion statable in one sentence), say so and route straight to `implement` with that sentence as the plan; a spec for an obvious change is ceremony. The fast path still drills its sentence: state it, then test it. A sentence that cannot be stated, or that surfaces a fork or a second decision, was not obvious: run the interview. A genuine fork discovered mid-task is never guessed: stop, name it, let the user answer or switch to deep. If `verify` fails twice on a task judged obvious, the task was lying about its size: stop and drill it properly.

Deep mode (the `deep` skill is active): no sizing, no routing past the interview; the full session runs and the spec is always written.

Run the `core-interview` skill against the plan or design under discussion.

Shape of the session:

- Explore the project context before the first question: code, docs, recent commits.
- If the ask bundles several independent pieces, say so and drill the first piece; the rest queue up.
- Before settling a direction, put 2 or 3 genuinely different approaches on the table with trade-offs, leading with a recommendation. When a fork turns on look, feel, or flow that prose can't settle, build a throwaway mockup with fake data to react to instead, and discard it once the direction is picked.
- Cut ruthlessly: anything the stated constraints don't demand leaves the design.

## Domain awareness

The interview also challenges the plan against the project's existing domain model. During exploration, look for existing documentation:

- `CONTEXT.md` at the root (or `CONTEXT-MAP.md` + per-context `CONTEXT.md` files in a multi-context repo)
- ADRs in `docs/adr/` (and any context-scoped `docs/adr/` directories)

Create files lazily: only when you have something to write. If no `CONTEXT.md` exists, create one when the first term is resolved. If no `docs/adr/` exists, create it when the first ADR is needed.

**First contact.** When no `CONTEXT.md` exists and the codebase is nontrivial, offer a one-time seeding pass: distill candidate terms from the code and any existing docs, then confirm each through the interview. Only confirmed terms enter the glossary; a term nobody vouched for is not written.

During the session:

- **Challenge against the glossary.** When the user uses a term that conflicts with the existing language in `CONTEXT.md`, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y. Which is it?"
- **Sharpen fuzzy language.** When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account'. Do you mean the Customer or the User? Those are different things."
- **Discuss concrete scenarios.** When domain relationships are being discussed, stress-test them with specific scenarios that probe edge cases and force precision about the boundaries between concepts.
- **Cross-reference with code.** When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code cancels entire Orders, but you just said partial cancellation is possible. Which is right?"
- **Update `CONTEXT.md` inline.** When a term is resolved, update `CONTEXT.md` right there; don't batch. It is a glossary and nothing else: not a spec, not a scratchpad, not a home for implementation decisions. Format: [CONTEXT-FORMAT.md](CONTEXT-FORMAT.md).
- **Offer ADRs sparingly.** Only offer an ADR when all three are true: hard to reverse, surprising without context, the result of a real trade-off. If any is missing, skip it. Format: [ADR-FORMAT.md](ADR-FORMAT.md).

The session ends when every branch of the decision tree is resolved: state the settled design in a short summary and get explicit agreement before any implementation starts.

When the settled design is implementation work, write the spec to `docs/specs/<slug>.md` in the target project using [SPEC-FORMAT.md](SPEC-FORMAT.md): goal, non-goals, checkable acceptance criteria, verification commands. The spec steers the loop: `implement` builds from it, `verify` gates against it, `land` closes it out and asks whether to keep or delete the file.

## The tree does not fit this session: write the draft
When the decision tree cannot resolve here (decisions await research beyond this context, or the tree is simply too large for one session), do not force a settled spec out of an unsettled design. Write the spec as a **draft** instead: `Destination`, `Decisions so far` (empty), `Open decisions`, `Not yet specified` (fog), `Out of scope`. Each open decision carries a Mode:

- **AFK**: a `/research` subagent can resolve it alone. Fire one subagent per AFK decision, in parallel, in this session, each writing its findings to `docs/research/<slug>-<decision-slug>.md`.
- **HITL**: only a live exchange with the user resolves it. Never answer your own HITL question.

Writing the draft is one session's work: name the destination, sketch the frontier, write the draft, fire the AFK subagents, stop. It resolves nothing itself.

**Later sessions work the draft.** When a session opens a spec that still has an `## Open decisions` section:

1. Load the whole spec: the low-res view, not one decision's deep dive.
2. Pick the next open decision; if the user named one, use that. Claim it before working it.
3. Resolve it: AFK decisions read the findings the subagent left at `docs/research/<slug>-<decision-slug>.md`; HITL decisions are worked with the user through the `core-interview` skill.
4. Record the resolution in `Decisions so far`, and remove the decision from `Open decisions`. Graduate anything now sharp from `Not yet specified` into fresh open decisions. A decision revealed to sit beyond the destination is ruled out of scope instead of resolved.
5. When the last open decision closes, delete the `## Open decisions` section: the spec is settled and the loop takes over.

One decision per session, except AFK decisions already dispatched. If no fog surfaces at all (the way is clear and the journey fits one session), there is no draft; settle normally.
