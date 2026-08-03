# skills

Connected skills that carry work from fuzzy plan to landed branch, on any project. Not a pile of skills; one flow with a fast path and a deep dial.

## Install

Two paths, both for Claude Code. Pick one: installing both loads every skill twice.

**Plugin** (updates via version):

```bash
claude plugin marketplace add pwguler/skills
claude plugin install pwguler-skills
```

Or in a Claude Code session:

```bash
/plugin marketplace add pwguler/skills
/plugin install pwguler-skills
```

**`npx skills`**:

```bash
npx skills add pwguler/skills
```

Restart Claude Code after installing.

## The loop

The base suite (drill → implement → verify → land) implements the run-until-done loop: a bounded goal, a maker/checker cycle, an exit only on proven criteria. Fast path: an obvious task skips the interview; one sentence is the spec, once it passes the fork test. If `verify` fails twice, the task was lying: route back through drill. `/deep` is user-only and turns every fast path off for the session.

```mermaid
flowchart TD
    idea([idea or codebase friction]) --> drill["1. drill: settle the plan"]
    idea -- "design question needs hands-on probing" --> proto["prototype: throwaway artifact answers it"] --> drill
    drill -- "goal, non-goals, acceptance criteria" --> spec[("docs/specs/*.md")]
    drill -- "tree too big for one session" --> draft[("spec as draft: open decisions")]
    draft -- "sessions resolve decisions one at a time" --> spec
    spec --> impl

    subgraph cycle["2. the maker / checker cycle"]
        impl["implement (maker): failing test, minimum code"] --> verify["verify (checker): reject by default, quotes evidence"]
        verify -- "criterion fails" --> impl
        impl -. "bug: root cause first" .-> debug
        debug -.-> impl
    end

    verify -- "3 failed attempts on one criterion" --> you(["escalate to you"])
    verify -- "every criterion proven" --> land["3. land: fresh-eyes gate"]
    land -- "residue to ADRs, CONTEXT.md, ARCHITECTURE.md; spec kept unless dropped" --> done([branch closed])
```

The documents the suite maintains, all created lazily with no setup step: `CONTEXT.md` (domain glossary, born from the first resolved term), `ARCHITECTURE.md` (the system as it is), `docs/adr/` (hard-to-reverse decisions), `docs/specs/<slug>.md` (the loop's steering artifact; a spec kept after its branch is a record of why the code looks the way it does).

## When to use what

| Moment | Skill |
|---|---|
| New plan, feature, or design | `drill` |
| Design question needs a throwaway artifact before committing | `prototype` |
| Implementing a settled plan | `implement` |
| Bug or unexpected behavior | `debug` |
| About to claim done, fixed, or passing | `verify` |
| Existing code fights you | `architecture` |
| Reading legwork | `research` |
| Branch done, needs merging or a PR | `land` |
| Independent failures or tasks, two or more | `parallel` |
| Multi-task plan to execute hands-off | `parallel` |
| Authoring or editing a skill | `write-skill` |
| Learning a topic across sessions | `teach` |
| Risky or ambiguous work, full rigor wanted | `deep` |
| None of the above comes to mind | `which-skill` |
