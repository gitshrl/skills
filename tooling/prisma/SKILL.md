---
name: prisma
description: Model, migrate, and query a database with Prisma ORM. Use for schema changes, migrations, generated-client work, and when choosing between Prisma and other TypeScript ORMs.
---

Prisma is a schema-first ORM: the `.prisma` schema is the source of truth, and the TypeScript client is generated from it. Never hand-edit generated output.

## Workflow

```bash
npx prisma init
npx prisma migrate dev --name <change>   # dev: create + apply + regenerate
npx prisma migrate deploy                # prod/CI: apply committed migrations only
npx prisma generate                      # regenerate the client
npx prisma studio                        # browse data
npx prisma migrate status                # drift check
```

`migrate dev` authors migrations and may reset a dev database. `migrate deploy` only applies what is already committed and never resets. Using the wrong one in production is the classic way to lose data.

## The loop

1. Edit `schema.prisma`.
2. `prisma migrate dev --name <what-changed>` — writes SQL to `prisma/migrations/`.
3. Review the generated SQL. It is committed code; read it like code.
4. Client types regenerate automatically; TypeScript now fails wherever the model changed.

Commit `prisma/migrations/` always. That directory is the schema history, and `migrate deploy` replays it.

## v7 changed the shape

Prisma 7 is a breaking release. Confirm which major a project is on before touching it.

- **ESM only.** `"type": "module"` is required in `package.json`, and `tsconfig.json` needs `"module": "ESNext"` with `"moduleResolution": "bundler"`.
- **New `prisma-client` provider.** Rust-free and faster; the old `prisma-client-js` provider is slated for removal.
- **MongoDB is not supported on v7 yet.** A MongoDB project stays on v6.
- **Node ≥ 20.19, TypeScript ≥ 5.4.**

The docs publish a markdown version of every page by appending `.md` to the URL, plus `llms.txt` — read those directly instead of scraping HTML.

## Querying

```ts
const users = await prisma.user.findMany({
  where: { posts: { some: { published: true } } },
  include: { posts: true },
})
```

`include` returns full relations; `select` returns only named fields and is what you want on a hot path. Both narrow the return type, so over-fetching is visible in the types.

Use `prisma.$transaction([...])` for atomic multi-writes. Interactive transactions hold a connection for their whole callback — keep them short.

## When not to Prisma

- **drizzle-orm** — SQL-shaped, no codegen step, thin runtime. Better when the SQL matters more than the abstraction.
- **kysely** — a typed query builder, not an ORM. Best when you want to write SQL with type safety and nothing else.

Prisma earns its weight through migrations and generated types. If a project needs neither, it is overhead.

## Pitfalls

- **Never edit `prisma/migrations/` after it has been applied anywhere.** Write a new migration instead; the applied history is a shared fact.
- **`prisma db push` skips migration files.** It is for prototyping only. Using it on a database that also has migrations desynchronizes both.
- **Connection pool exhaustion in serverless.** Each instance opens its own pool. Use a pooler (PgBouncer, Prisma Accelerate) or the runtime will hit the connection cap under load.
- **`prisma generate` is not automatic in CI.** A clean checkout has no generated client; run it before typecheck or the build fails on missing types.
- **N+1 hides behind relation access.** Fetch relations in the query with `include`/`select` rather than looping.
- **Verify the version.** `npm view prisma version`, or read `@prisma/client` in the lockfile. v6 and v7 differ enough that advice for one misleads on the other.
