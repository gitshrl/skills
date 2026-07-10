---
name: core-interview
description: Internal support skill, the relentless interview loop other skills delegate to. Use only when another skill or the user explicitly triggers it, never on your own.
---

Interview the user relentlessly about every aspect of the topic at hand until you reach a shared understanding. Walk down each branch of the decision tree, resolving dependencies between decisions one-by-one. Relentless means no branch left unresolved, not one round-trip per branch.

- Ask only questions whose answer would change what gets built. When your recommendation is strong and the cost of being wrong is low, don't ask: adopt it, record it as an assumption, move on.
- Real forks get asked one at a time, waiting for the answer, each with your recommended answer. Low-stakes clarifications batch into a single message.
- If a question can be answered by exploring the codebase, explore the codebase instead of asking.
- The closing summary lists every adopted assumption for a one-pass veto. A vetoed assumption reopens only that branch.
- Deep mode (the `deep` skill is active): ask every branch one at a time, adopt no assumptions.
