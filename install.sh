#!/usr/bin/env bash
# One-command bootstrap for a fresh machine:
#   - all skills      -> ~/.claude/skills/
#   - CLAUDE.md/RTK.md -> ~/.claude/
#   - rtk (Rust Token Killer) installed + Claude Code hook wired
#   - Claude Code plugins + marketplaces installed
#
# Run from a clone:        ./install.sh
# Or straight from GitHub: curl -fsSL https://raw.githubusercontent.com/gitshrl/skills/main/install.sh | bash
set -euo pipefail

REPO_URL="https://github.com/gitshrl/skills.git"
CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills"

log() { printf '\033[1;36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!! \033[0m %s\n' "$*"; }

# --- Locate the repo: run-in-place if SKILL dirs are next to us, else clone ---
SRC="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
if [ -z "$SRC" ] || [ ! -f "$SRC/CLAUDE.md" ]; then
    SRC="${TMPDIR:-/tmp}/gitshrl-skills-$$"
    log "cloning $REPO_URL"
    git clone --depth 1 "$REPO_URL" "$SRC"
    CLEANUP="$SRC"
fi

mkdir -p "$SKILLS_DIR"

# --- 1) Skills -> ~/.claude/skills/ (every dir with a SKILL.md) ---
log "installing skills -> $SKILLS_DIR"
count=0
for d in "$SRC"/*/; do
    [ -f "${d}SKILL.md" ] || continue
    name="$(basename "$d")"
    dest="$SKILLS_DIR/$name"
    # Guard: if the repo was cloned directly into ~/.claude/skills, the source
    # IS the destination — skip the rm/cp (it would delete then copy nothing).
    if [ "${d%/}" -ef "$dest" ] 2>/dev/null; then
        count=$((count + 1))
        continue
    fi
    rm -rf "${dest:?}"
    cp -r "$d" "$dest"
    count=$((count + 1))
done
log "  $count skills installed"

# --- 2) CLAUDE.md (+ RTK.md if present) -> ~/.claude/ (backup existing) ---
for f in CLAUDE.md RTK.md; do
    [ -f "$SRC/$f" ] || continue
    [ -f "$CLAUDE_DIR/$f" ] && cp "$CLAUDE_DIR/$f" "$CLAUDE_DIR/$f.bak.$(date +%s)"
    cp "$SRC/$f" "$CLAUDE_DIR/$f"
    log "deployed $f"
done

# --- 3) rtk: install binary + wire the Claude Code hook ---
if command -v rtk >/dev/null 2>&1; then
    log "rtk already installed ($(rtk --version 2>/dev/null || echo '?'))"
else
    log "installing rtk"
    curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/master/install.sh | sh
fi
if command -v rtk >/dev/null 2>&1; then
    log "wiring rtk Claude Code hook (rtk init -g --auto-patch)"
    rtk init -g --auto-patch || warn "rtk init failed — run: rtk init -g --auto-patch"
else
    warn "rtk not on PATH after install — add ~/.local/bin to PATH, then: rtk init -g"
fi

# --- 4) Plugins: add marketplaces + install ---
if command -v claude >/dev/null 2>&1; then
    log "adding marketplaces + installing plugins"
    # marketplace name -> github repo
    claude plugin marketplace add anthropics/claude-plugins-official 2>/dev/null || true
    claude plugin marketplace add forrestchang/andrej-karpathy-skills 2>/dev/null || true
    claude plugin marketplace add DietrichGebert/ponytail 2>/dev/null || true
    # `add` skips cloning if the marketplace is already declared in settings, which
    # leaves a cache-miss on a fresh machine. force-populate the cache before install.
    claude plugin marketplace update 2>/dev/null || true
    for p in \
        "rust-analyzer-lsp@claude-plugins-official" \
        "superpowers@claude-plugins-official" \
        "andrej-karpathy-skills@karpathy-skills" \
        "ponytail@ponytail"; do
        if out=$(claude plugin install "$p" -s user 2>&1); then
            log "  + $p"
        else
            warn "  plugin $p failed — error below; retry: claude plugin install $p -s user"
            printf '%s\n' "$out" | tail -4
        fi
    done
else
    warn "claude CLI not found — install Claude Code first, then re-run for plugins"
fi

[ -n "${CLEANUP:-}" ] && rm -rf "$CLEANUP"
log "done. Restart Claude Code to load skills + plugins."
