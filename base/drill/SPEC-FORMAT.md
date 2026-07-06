# Spec Format

One spec per work item, at `docs/specs/<slug>.md` in the target project. `drill` creates it when the decision tree resolves into implementation work; `land` deletes it when the branch closes. A spec is branch-lifetime steering, never permanent documentation.

## Template

```markdown
# <slug>

## Goal
One sentence: what this work item delivers.

## Non-goals
What this work must not touch or change. These fence the diff.

## Acceptance criteria
- AC-1: <a checkable statement; a command or test can prove it true or false>
- AC-2: ...

## Verification
The exact commands that prove the criteria, one per line.
```

## Rules

- Every criterion is checkable. If no command or test can prove it, rewrite it until one can.
- Non-goals are load-bearing: `verify` fails work that changes what a non-goal fences off.
- The spec states the destination, not the route: no implementation steps, no file lists.
- Durable residue outlives the spec elsewhere: decisions go to `docs/adr/`, settled terms to `CONTEXT.md`. The spec itself dies with the branch.
