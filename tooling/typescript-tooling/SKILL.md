---
name: typescript-tooling
description: Choose and run TypeScript/JavaScript tooling — package manager, compiler, linter, formatter, bundler, test runner. Use when setting up a TS project, picking between npm/pnpm/bun or eslint/biome/oxlint, or configuring a build.
---

The JS ecosystem replaces its tooling faster than it stabilizes it. Default to the boring choice; adopt the fast one when the project can absorb a break.

## Package manager

**pnpm** for anything with more than one package. Content-addressed store, strict by default, real workspace support.

```bash
pnpm install
pnpm add <pkg>
pnpm add -D <pkg>
pnpm -F <workspace-pkg> <cmd>   # run in one workspace member
```

Pin it in `package.json` so everyone resolves the same resolver:

```json
"packageManager": "pnpm@11.17.0"
```

npm is fine for a single package with no workspace. yarn is legacy unless already in use.

**bun** is both a package manager and a runtime; treat those decisions separately. As a package manager it is fast and fine. As a *production runtime* check its release cadence first — a long publish gap on the npm registry is a real signal, and it has had one.

## Compiler

TypeScript 7 is the Go-native rewrite: an order of magnitude faster, and a breaking change in shape, not just speed.

- The `tsserver` binary is **gone**; it speaks LSP now. Editor and IDE plugins need to support it.
- Some monorepo tooling still targets TS 6.

Verify before adopting on a live project:

```bash
npx tsc --version
node -e "console.log(require('typescript/package.json').version)"
```

On a greenfield project, take TS 7. On a project people ship from daily, confirm the editor path works first.

## Lint and format

Three live options, and real projects have picked all three:

| Tool | Take it when |
|---|---|
| **ESLint + Prettier** | Maximum plugin coverage, existing config, no appetite for churn |
| **Biome** | One binary for lint *and* format, stable, simple config |
| **oxlint + oxfmt** | Fastest; type-aware rules now available. Note oxfmt matured later than the linter |

Do not run two formatters. Pick one and delete the other's config, or they will fight in CI.

ESLint v9 is end-of-life — if a project is still on it, upgrading to v10 is maintenance, not a nice-to-have.

## Build and test

- **Vite** for apps. Vite 8 replaced both esbuild and Rollup internally with Rolldown — same API, different engine underneath.
- **tsdown** / **tsup** for libraries.
- **Vitest** for tests. `bun test` if the project is already all-in on bun.

```bash
pnpm vitest run              # CI
pnpm vitest                  # watch
pnpm vitest --coverage
```

## Monorepo

**Turborepo** for task orchestration and caching. **pnpm workspaces** for linking. They compose; Turbo does not replace the package manager.

Check Turbo's declared TypeScript support before assuming it works with TS 7.

## Pitfalls

- **`"type": "module"` is not optional any more.** Half the ecosystem is ESM-only. Setting it late is a painful migration; set it at the start.
- **A dependency's types can break your build without its runtime changing.** Pin `typescript` exactly and upgrade deliberately.
- **`npx` runs whatever is on npm right now.** In CI use `pnpm exec` against a locked version instead.
- **Verify versions from the registry, not from memory.** `npm view <pkg> version` and `https://registry.npmjs.org/<pkg>` are authoritative; this ecosystem moves monthly.
- **Do not mix package managers.** A `package-lock.json` next to a `pnpm-lock.yaml` means two different dependency trees; delete the one you are not using.
