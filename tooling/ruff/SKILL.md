---
name: ruff
description: Lint and format Python with ruff. Use when checking, fixing, or formatting Python code, and when configuring lint rules in a project.
---

Ruff replaces flake8, isort, black, pyupgrade, autoflake, and most of pylint, in one binary.

## Commands

```bash
ruff check .                  # lint
ruff check --fix .            # lint and apply safe fixes
ruff check --diff .           # show fixes without writing
ruff format .                 # format
ruff format --diff .          # show formatting without writing
```

Under uv: `uvx ruff check .`, or `uv run ruff check .` when it is a project dependency.

## Restraint is the rule

Ruff makes it trivial to rewrite an entire codebase. Do not.

- **Check before formatting.** If `ruff format --diff` shows changes throughout files you did not touch, the project does not use ruff for formatting. Formatting anyway buries the real diff in noise. Leave it.
- **Scope fixes to what you are editing.** `ruff check --diff` shows what would change; apply only to files already in your diff, unless the user asks for a sweep.
- **A separate formatting commit, never a mixed one.** Formatting churn and a behavior change in the same commit make review impossible.

## Configuration

Lives in `pyproject.toml` under `[tool.ruff]`, or `ruff.toml`.

```toml
[tool.ruff]
line-length = 100

[tool.ruff.lint]
select = ["E", "F", "I", "UP", "B"]
ignore = ["E501"]

[tool.ruff.lint.per-file-ignores]
"tests/**" = ["S101"]
```

Two viable strategies, and they are opposite:

**Broad** — `select = ["ALL"]` with an explicit ignore list. Best on a new codebase; every new rule arrives opted-in and must be justified to remove.

**Narrow** — select only rules that caught a real bug in this codebase. Best on a large existing codebase where `ALL` would produce thousands of findings nobody triages. A single well-chosen rule that is actually enforced beats 400 that are ignored.

Pick one deliberately. Do not enable rules because they exist.

## Pitfalls

- **Ruff 0.16 changed the default ruleset from 59 to 413 rules.** Upgrading without a pinned version can turn a green CI red on untouched code. Pin exactly (`ruff==0.16.0`), upgrade on purpose.
- **`--fix` has unsafe fixes behind a flag.** `--unsafe-fixes` can change behavior; review that diff, do not trust it blind.
- **The formatter and the linter can disagree.** If `ruff check` wants something `ruff format` undoes, the lint rule is wrong for the project — disable it rather than fighting the loop.
- **`# noqa` needs a code.** Bare `# noqa` silences everything on the line, including the bug you have not written yet. Write `# noqa: E731`.
