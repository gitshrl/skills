---
name: prototype
description: "Build a throwaway prototype to flesh out a design before committing to it. Routes between two branches: a runnable terminal app for state/business-logic questions, or several radically different UI variations toggleable from one route. Use when the user wants to prototype, sanity-check a data model or state machine, mock up a UI, explore design options, or says \"prototype this\", \"let me play with it\", \"try a few designs\"."
---

A prototype is **throwaway code that answers a question**. The question decides the shape.

Fast by default: build the smallest artifact that answers the question (logic: the minimal terminal app; UI: two contrasting variations). Deep mode (the `deep` skill is active): the exhaustive artifact, several radically different variations or every hard case pushed.

## Pick a branch

Identify which question is being answered: from the user's prompt, the surrounding code, or by asking if the user is around:

- **"Does this logic / state model feel right?"** → [LOGIC.md](LOGIC.md). Build a tiny interactive terminal app that pushes the state machine through cases that are hard to reason about on paper.
- **"What should this look like?"** → [UI.md](UI.md). Generate several radically different UI variations on a single route, switchable via a URL search param and a floating bottom bar.

The two branches produce very different artifacts. Getting this wrong wastes the whole prototype. If the question is genuinely ambiguous and the user isn't reachable, default to whichever branch better matches the surrounding code (a backend module → logic; a page or component → UI) and state the assumption at the top of the prototype.

## Rules that apply to both

1. **Throwaway from day one, and clearly marked as such.** Locate the prototype code close to where it will actually be used (next to the module or page it's prototyping for) so context is obvious, but name it so a casual reader can see it's a prototype, not production. For throwaway UI routes, obey whatever routing convention the project already uses; don't invent a new top-level structure.
2. **One command to run.** Whatever the project's existing task runner supports: `pnpm <name>`, `python <path>`, `bun <path>`, etc. The user must be able to start it without thinking.
3. **No persistence by default.** State lives in memory. Persistence is the thing the prototype is _checking_, not something it should depend on. If the question explicitly involves a database, hit a scratch DB or a local file with a clear "PROTOTYPE: wipe me" name.
4. **Skip the polish.** No tests, no error handling beyond what makes the prototype _runnable_, no abstractions. The point is to learn something fast and move on.
5. **Surface the state.** After every action (logic) or on every variant switch (UI), print or render the full relevant state so the user can see what changed.
6. **Capture it when done.** Fold the validated decision into the real code, then commit the prototype itself to a throwaway branch out of main (`proto/<slug>`) and leave a pointer to that branch where the verdict is recorded. Main keeps only the validated decision; the prototype survives as a primary source.

## When done

The _answer_ is what main keeps. Capture it somewhere durable (commit message, ADR, or a `NOTES.md`) along with the question it was answering and the pointer to the `proto/<slug>` branch. An ADR is the right home only when the answer passes the three-part test (hard to reverse, surprising without context, the result of a real trade-off); then use the format in [ADR-FORMAT.md](../drill/ADR-FORMAT.md). Otherwise a commit message or `NOTES.md` is enough. If the user is around, that capture is a quick conversation; if not, leave the placeholder so they (or you, on the next pass) can fill in the verdict before the prototype leaves main.
