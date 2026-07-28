---
name: rust-tooling
description: Build, lint, format, test, and audit Rust with the cargo toolchain. Use for any cargo work, clippy or rustfmt runs, dependency auditing, or toolchain pinning.
---

The Rust toolchain ships its own linter, formatter, and test runner. Reach outside it only for the gaps: faster test output, security auditing, license policy.

## Official, installed by rustup

```bash
cargo build --release
cargo clippy --all-targets --all-features -- -D warnings
cargo fmt --check              # CI
cargo fmt                      # local
cargo test
```

`--all-targets` matters: without it clippy skips tests, benches, and examples, which is exactly where sloppy code hides. `-D warnings` is what makes CI fail rather than merely complain.

## Third-party, worth adding

```bash
cargo install cargo-nextest    # faster test runner, far better output
cargo nextest run

cargo install cargo-deny       # licenses, bans, advisories, sources
cargo deny check

cargo install cargo-audit      # RustSec advisories only
cargo audit
```

`cargo-deny` supersedes `cargo-audit` for most projects: it covers advisories *and* license policy *and* duplicate-version bans from one config. Use `cargo-audit` alone when advisories are all you want.

`cargo-binstall` fetches prebuilt binaries instead of compiling them; on CI it turns a multi-minute `cargo install` into seconds.

## Pinning the toolchain

`rust-toolchain.toml` at the repo root, committed:

```toml
[toolchain]
channel = "1.97.1"
components = ["clippy", "rustfmt"]
```

rustup honors this automatically. Everyone — including CI — gets the same compiler without being told.

## Error handling convention

The split is near-universal and worth following:

- **`thiserror`** in libraries. Typed errors the caller can match on.
- **`anyhow`** in binaries. Context chains, no enum ceremony.
- **`eyre`/`color-eyre`** in CLIs that want pretty reports.
- **`miette`** only when source-span diagnostics matter (a compiler, a parser).

Do not put `anyhow` in a library's public API — it erases the type information the caller needs.

## Verifying versions

crates.io lies about bundled tools. `clippy` and `rustfmt` on crates.io are abandoned 2017-2018 placeholders; the real versions live only in the rustup channel manifest.

```bash
rustc --version && cargo --version
cargo clippy --version && cargo fmt --version
```

For the current stable release, read the dist manifest, not a blog post:
`https://static.rust-lang.org/dist/channel-rust-stable.toml`

## Pitfalls

- **Clippy without `--all-targets` gives false confidence.** Test code goes unlinted.
- **`cargo test` compiles test binaries per target.** Consolidating integration tests into one `tests/it/main.rs` with `mod` declarations noticeably cuts build time on large suites.
- **MSRV is a promise.** If `rust-version` is set in `Cargo.toml`, CI must actually build with it — a dependency bump can raise the real floor silently.
- **`cargo update` is not `cargo upgrade`.** The former moves within your semver ranges; the latter (from `cargo-edit`) rewrites the ranges themselves.
- **cranelift is nightly-only.** It is listed in the stable manifest with zero available targets — present in the component list, not actually installable.
