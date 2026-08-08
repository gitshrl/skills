---
name: core-interview
description: Internal support skill, the relentless interview loop other skills delegate to. Use only when another skill or the user explicitly triggers it, never on your own.
---

Interview the user relentlessly about every aspect of the topic at hand until you reach a shared understanding. Walk down each branch of the decision tree, resolving dependencies between decisions one-by-one. Relentless means no branch left unresolved, not one round-trip per branch.

- Ask only questions whose answer would change what gets built. When your recommendation is strong and the cost of being wrong is low, don't ask: adopt it, record it as an assumption, move on.
- Real forks go through the question tool one at a time, waiting for each answer, the options carrying your candidate answers with the recommended one first. Low-stakes clarifications batch into a single call.
- Typing an answer the options missed stays open, so the tool never narrows a fork.
- If a question can be answered by exploring the codebase, explore the codebase instead of asking. Facts are yours to find, never the user's. A lookup runs in a subagent and does not stall the interview: only the questions downstream of that fact wait for it.
- When the user can't put the target behavior into words, ask for a reference implementation: source code, even in another language or library, whose semantics to reimplement. Source beats prose or a screenshot.
- The closing summary lists every adopted assumption for a one-pass veto. A vetoed assumption reopens only that branch.
- Deep mode (the `deep` skill is active): ask every branch one at a time, adopt no assumptions.
