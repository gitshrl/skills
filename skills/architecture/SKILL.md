---
name: architecture
description: Find deepening opportunities in a codebase, informed by the domain language in CONTEXT.md and the decisions in docs/adr/. Use when the user wants to improve architecture, find refactoring opportunities, consolidate tightly-coupled modules, or make a codebase more testable and AI-navigable.
---

Surface architectural friction and propose **deepening opportunities**: refactors that turn shallow modules into deep ones. The aim is testability and AI-navigability.

Fast by default: scope the exploration to the area the user names or the friction they describe, present the top candidates, and hold the rival-interface sub-agent fan-out until asked. Deep mode (the `deep` skill is active): whole-codebase sweep, full candidate list, sub-agent interface exploration on the picked candidate.

## Glossary

Use these terms exactly in every suggestion. Consistent language is the point. Don't drift into "component," "service," "API," or "boundary." Full definitions in [LANGUAGE.md](LANGUAGE.md).

- **Module**: anything with an interface and an implementation (function, class, package, slice).
- **Interface**: everything a caller must know to use the module: types, invariants, error modes, ordering, config. Not just the type signature.
- **Implementation**: the code inside.
- **Depth**: leverage at the interface, a lot of behavior behind a small interface. **Deep** = high leverage. **Shallow** = interface nearly as complex as the implementation.
- **Seam**: where an interface lives; a place behavior can be altered without editing in place. (Use this, not "boundary.")
- **Adapter**: a concrete thing satisfying an interface at a seam.
- **Leverage**: what callers get from depth.
- **Locality**: what maintainers get from depth (change, bugs, knowledge concentrated in one place).

Key principles (see [LANGUAGE.md](LANGUAGE.md) for the full list):

- **Deletion test**: imagine deleting the module. If complexity vanishes, it was a pass-through. If complexity reappears across N callers, it was earning its keep.
- **The interface is the test surface.**
- **One adapter = hypothetical seam. Two adapters = real seam.**

This skill is _informed_ by the project's domain model: `CONTEXT.md` and any `docs/adr/`. The domain language gives names to good seams; ADRs record decisions the skill should not re-litigate. See [CONTEXT-FORMAT.md](../drill/CONTEXT-FORMAT.md) and [ADR-FORMAT.md](../drill/ADR-FORMAT.md). When the work touches a toolchain (Python, Rust, TypeScript, Prisma), [TOOLING.md](TOOLING.md) carries the commands, configuration shape, and pitfalls for it.

## Process

### 1. Explore

Read existing documentation first:

- `ARCHITECTURE.md` at the root: the prior map of modules, seams, and invariants. Re-derive only what changed since it was written.
- `CONTEXT.md` (or `CONTEXT-MAP.md` + each `CONTEXT.md` in a multi-context repo)
- Relevant ADRs in `docs/adr/` (and any context-scoped `docs/adr/` directories)

If any of these files don't exist, proceed silently. Don't flag their absence or suggest creating them upfront. Exception: when `ARCHITECTURE.md` is missing on a nontrivial codebase, offer once to seed it from this run's exploration, using [ARCHITECTURE-FORMAT.md](ARCHITECTURE-FORMAT.md); write only what the user confirms.

Then use the Agent tool with `subagent_type=Explore` to walk the codebase. Don't follow rigid heuristics. Explore organically and note where you experience friction:

- Where does understanding one concept require bouncing between many small modules?
- Where are modules **shallow** (interface nearly as complex as the implementation)?
- Where have pure functions been extracted just for testability, but the real bugs hide in how they're called (no **locality**)?
- Where do tightly-coupled modules leak across their seams?
- Which parts of the codebase are untested, or hard to test through their current interface?

Apply the **deletion test** to anything you suspect is shallow: would deleting it concentrate complexity, or just move it? A "yes, concentrates" is the signal you want.

### 2. Present candidates

Present a numbered list of deepening opportunities. For each candidate:

- **Files**: which files/modules are involved
- **Problem**: why the current architecture is causing friction
- **Solution**: plain English description of what would change
- **Benefits**: explained in terms of locality and leverage, and also in how tests would improve

**Use CONTEXT.md vocabulary for the domain, and [LANGUAGE.md](LANGUAGE.md) vocabulary for the architecture.** If `CONTEXT.md` defines "Order," talk about "the Order intake module", not "the FooBarHandler," and not "the Order service."

**ADR conflicts**: if a candidate contradicts an existing ADR, only surface it when the friction is real enough to warrant revisiting the ADR. Mark it clearly (e.g. _"contradicts ADR-0007, but worth reopening because…"_). Don't list every theoretical refactor an ADR forbids.

Do NOT propose interfaces yet. Ask the user: "Which of these would you like to explore?"

### 3. Interview loop

Once the user picks a candidate, run the `core-interview` skill against it. The decision tree to walk: constraints, dependencies, the shape of the deepened module, what sits behind the seam, what tests survive.

Side effects happen inline as decisions crystallize:

- **Naming a deepened module after a concept not in `CONTEXT.md`?** Add the term to `CONTEXT.md`, same discipline as `/drill` (see [CONTEXT-FORMAT.md](../drill/CONTEXT-FORMAT.md)). If it doesn't exist, create it lazily when the first term is resolved.
- **Sharpening a fuzzy term during the conversation?** Update `CONTEXT.md` right there.
- **Did the settled design change the system's shape (new module, moved seam, new invariant)?** Update `ARCHITECTURE.md` right there, per [ARCHITECTURE-FORMAT.md](ARCHITECTURE-FORMAT.md).
- **User rejects the candidate with a load-bearing reason?** Offer an ADR, framed as: _"Want me to record this as an ADR so future architecture reviews don't re-suggest it?"_ Only offer when the reason would actually be needed by a future explorer to avoid re-suggesting the same thing. Skip ephemeral reasons ("not worth it right now") and self-evident ones. See [ADR-FORMAT.md](../drill/ADR-FORMAT.md).
- **Want to explore alternative interfaces for the deepened module?** See [INTERFACE.md](INTERFACE.md).
