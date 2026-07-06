# PRD-like artifacts for agent loops

## TL;DR

Every surveyed practice separates the loop mechanics from a written statement of goal plus checkable done conditions, and every one makes that statement a file, not conversation context. Loop engineering calls a loop without a state file amnesiac; spec-kit and Kiro both put acceptance criteria in a per-feature spec file that later phases trace back to; Anthropic's own Claude Code guidance says to write a self-contained spec with an end-to-end verification step, then execute and review against that file from fresh sessions. A full PRD is not needed. What verify needs is a small per-work-item spec: goal, non-goals, checkable acceptance criteria, verification commands. Created by drill when the plan settles, consumed by implement and verify, deleted at land.

## Findings

### Loop engineering (github.com/cobusgreyling/loop-engineering)

Sources: README.md, LOOP.md, docs/concepts.md, docs/loop-design-checklist.md (all at https://github.com/cobusgreyling/loop-engineering).

Loop engineering replaces per-prompt crafting with designed control structures: "Stop prompting. Design the loop. Get a score." and "You shouldn't be prompting coding agents anymore. You should be designing loops that prompt your agents." (README.md).

The loop's building blocks are automations/scheduling, worktrees, skills, plugins/connectors, sub-agents, plus memory/state as a durable spine outside conversations (README.md). Skills encode intent: conventions and "we don't do it this way" written once, read every run (docs/concepts.md). The concepts doc defines the core move as recursive goal definition: "define purpose, let the agent iterate (with sub-agents and external memory) until done or until the loop escalates to a human."

On verification: "The implementer must never grade its own homework" (docs/concepts.md). The design checklist (docs/loop-design-checklist.md) requires a single clear goal stated in one sentence, explicit non-goals, implementer and verifier separated, "Implementer cannot mark its own work done", and the verifier running tests in an isolated worktree before approving. Its red flags include a verifier that shares the implementer's session and a loop with no state file, which "has amnesia every run". State discipline: the loop reads prior state at the start of every run, writes outcomes and timestamps, and prunes resolved items. The README's blunt caution: "Verification is still on you. Unattended loops make unattended mistakes."

The framing that matters for this question: goals and loop mechanics are distinct concerns. Loops discover and execute; goals define what finishing means. The goal statement and the state file are the steering artifacts; skills are the standing conventions.

### GitHub spec-kit (github.com/github/spec-kit)

Sources: repo README (https://github.com/github/spec-kit), templates/spec-template.md (https://github.com/github/spec-kit/blob/main/templates/spec-template.md).

The flow produces four artifacts: constitution.md (governing principles), spec.md (user stories and functional requirements), plan.md (technical approach), tasks.md (dependency-ordered task breakdown). Commands: /speckit.constitution, /speckit.specify, /speckit.clarify, /speckit.plan, /speckit.tasks, /speckit.analyze, /speckit.implement.

Acceptance criteria live in spec.md. The template's mandatory sections are "User Scenarios & Testing", "Requirements", and "Success Criteria". Each user story carries an "Independent Test" and "Acceptance Scenarios" in Given/When/Then form. Requirements are "System MUST" statements. Success criteria are measurable outcomes with stable IDs ("SC-001: [Measurable metric]"). Completion is checked in layers: /speckit.clarify runs coverage-based questioning before planning, /speckit.analyze runs cross-artifact consistency and coverage analysis before implementation, and the spec's review checklist is checked off item by item against the built feature.

### Kiro (kiro.dev)

Sources: https://kiro.dev/docs/specs/ and https://kiro.dev/docs/specs/feature-specs/.

A Kiro spec is three files: "requirements.md (or bugfix.md) - Captures user stories, acceptance criteria, or bug analysis in structured notation"; "design.md - Documents technical architecture, sequence diagrams, and implementation considerations"; "tasks.md - Provides a detailed implementation plan with discrete, trackable tasks."

Acceptance criteria live in requirements.md in EARS notation: "WHEN a user submits a form with invalid data THE SYSTEM SHALL display validation errors next to the relevant fields." Stated benefits: clarity, testability ("Each requirement can be directly translated into test cases"), and traceability ("Individual requirements can be tracked through implementation"). Tasks derive from requirements through design, and all three files are auto-included in conversation context so the agent's work stays aligned with the documented spec. Task status (in progress, completed) is tracked per task.

### Anthropic Claude Code guidance (code.claude.com/docs/en/best-practices)

Source: https://code.claude.com/docs/en/best-practices (the canonical successor to the anthropic.com best-practices post).

On completion gates: "Claude stops when the work looks done. Without a check it can run, 'looks done' is the only signal available, and you become the verification loop." The fix is a check that produces pass or fail, escalating from in-prompt checks to /goal conditions to Stop hooks to "a verification subagent ... so the agent doing the work isn't the one grading it."

On specs: the interview pattern ends with "write a complete spec to SPEC.md", then "start a fresh session to execute it". And: "The most useful specs are self-contained: they name the files and interfaces involved, state what is out of scope, and end with an end-to-end verification step that proves the feature works."

On review: the adversarial review prompt is explicitly file-anchored: "Use a subagent to review the rate limiter diff against PLAN.md. Check that every requirement is implemented, the listed edge cases have tests, and nothing outside the task's scope changed." A fresh-context reviewer cannot see the conversation that produced the work; the criteria must exist as a file for this pattern to function at all.

## Answers

### a) What does loop engineering say the loop needs as its steering artifact?

Three things. A goal statement: one sentence of purpose plus explicit non-goals, defined before the loop runs, because goals define what finishing means while loops only execute. Skills: standing conventions written once and read every run. A durable state file outside any conversation: read at the start of every run, written with outcomes at the end, pruned as items resolve. A loop without the state file "has amnesia every run". Completion is never self-declared: the implementer cannot mark its own work done; a separate verifier runs tests in isolation and human gates catch high-risk paths.

### b) Does goal plus acceptance criteria deserve a durable doc distinct from ADR and CONTEXT.md?

Distinct, yes. Permanently durable, no.

The concern is real and unowned. ADRs record why a decision was made; CONTEXT.md records what words mean. Neither states "done means X" for a piece of work. All four sources treat that statement as its own artifact: spec-kit's spec.md with Success Criteria IDs, Kiro's requirements.md with EARS criteria, loop engineering's goal-plus-non-goals checklist items, Anthropic's SPEC.md/PLAN.md. None of them park it in a decision record or a glossary.

The counterargument, tests are the acceptance criteria in a test-first flow, holds for behavior but fails on three points. First, non-goals: a test suite cannot express "nothing outside the task's scope changed", which Anthropic's review prompt checks explicitly. Second, coverage: "all tests pass" only equals "goal met" if the tests are complete, and the implementer wrote the tests; a criteria list is what a checker compares the test suite against to find the missing case. Third, session independence: verify and any fresh-context reviewer need the criteria without the conversation that produced them. Loop engineering names this failure directly (verifier in the same session as the implementer is a red flag) and Anthropic's reviewer pattern reads criteria from a file because a subagent has no other access to them.

But the artifact's lifetime should match the work, not the repo. Spec-kit and Kiro keep specs per feature; Anthropic's SPEC.md is written for one execution session. Once the work lands, the tests are the living record of behavior and an ADR captures any decision worth keeping. A pile of stale spec files would rot the way the deleted PRD skill did. So: durable across sessions within one piece of work, deleted when the work lands. That is handoff-doc lifetime with verify-gate content.

### c) Minimal artifact shape for verify

One Markdown file per work item, for example `docs/specs/<slug>.md`.

Fields:

- **Goal**: one sentence.
- **Non-goals**: what this work must not touch or attempt.
- **Acceptance criteria**: numbered list (AC-1, AC-2, ...). Each criterion is observable and names its check: a test file or name, a command plus expected output, or a manual step with expected result. EARS or Given/When/Then phrasing where it helps; the binding requirement is that each line is checkable, not the notation.
- **Verification**: the exact commands verify runs (test suite, build, lint, any end-to-end check).

Lifecycle:

- **Created** by drill, at the moment the plan settles, as the interview's output. Ten minutes of writing, one screen of text.
- **Consumed** by implement (each acceptance criterion becomes a failing test first), by verify (run every criterion's check, read the output, report per criterion), and by any reviewer subagent (diff checked against goal and non-goals).
- **Deleted** by land. Decisions that emerged go to docs/adr/; new domain terms go to CONTEXT.md; the tests stay. The spec itself does not outlive the branch.

## Recommendation for this suite

The base skills already cover the loop engineering blocks: drill is goal definition, implement is the maker, verify is the checker, worktree is isolation, delegate and parallel are the sub-agent splits, handoff is cross-session state for interrupted work. The one uncovered block is the goal-plus-criteria file that makes verify a real gate instead of a vibe check against conversation memory.

Do not resurrect a PRD skill. The old one died of issue-tracker coupling, and nothing surveyed requires a product document. Instead:

1. Extend drill: when a plan settles, drill writes the spec file above. It is the natural owner; the interview already surfaces goal, scope edges, and success conditions, and today that output evaporates into context.
2. Extend verify: if a spec file exists for the current work, gate against it criterion by criterion and quote the evidence per criterion. If none exists, verify says so and falls back to tests plus build, which is the honest description of what it can prove.
3. Extend land: delete the spec file after routing any durable residue to docs/adr/ and CONTEXT.md.
4. Leave implement almost alone: one line telling it to turn acceptance criteria into the first failing tests when a spec exists.

This is one artifact and three one-line skill edits, not a new skill. It closes the exact gap the sources agree on: the completion gate needs written criteria that survive session boundaries, and nothing in the suite writes them today.
