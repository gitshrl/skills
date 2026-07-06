---
name: drill
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, drill into their design, or says "drill this" or "drill me".
---

Run the `core-interview` skill against the plan or design under discussion.

Shape of the session:

- Explore the project context before the first question. Questions the codebase, docs, or recent commits can answer are never asked.
- If the ask bundles several independent pieces, say so and drill the first piece; the rest queue up.
- Before settling a direction, put 2 or 3 genuinely different approaches on the table with trade-offs, leading with a recommendation.
- Cut ruthlessly: anything the stated constraints don't demand leaves the design.

The session ends when every branch of the decision tree is resolved: state the settled design in a short summary and get explicit agreement before any implementation starts.

When the settled design is implementation work, write the spec to `docs/specs/<slug>.md` in the target project using [SPEC-FORMAT.md](SPEC-FORMAT.md): goal, non-goals, checkable acceptance criteria, verification commands. The spec steers the loop: `implement` builds from it, `verify` gates against it, `land` deletes it.
