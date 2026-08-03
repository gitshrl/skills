#!/usr/bin/env bash
# One-command bootstrap for a fresh machine:
#   - skills          -> ~/.agents/skills (opencode and codex)
#   - CLAUDE.md/RTK.md -> ~/.claude/
#   - codex instructions -> ~/.codex/AGENTS.md + RTK.md symlinked to ~/.claude/
#   - rtk (Rust Token Killer) installed + Claude Code hook wired
#
# Claude Code users: install the suite as a plugin instead of copying skills:
#   claude plugin marketplace add pwguler/skills
#   claude plugin install pwguler-skills
# The plugin is read-only and updates via its version. Installing both the
# plugin and legacy copies in the Claude Code skills directory loads every
# skill twice.
#
# ~/.agents/skills serves opencode and codex, which both scan it natively.
#
# Run from a clone:        ./install.sh
# Or straight from GitHub: curl -fsSL https://raw.githubusercontent.com/pwguler/skills/main/install.sh | bash
set -euo pipefail

REPO_URL="https://github.com/pwguler/skills.git"
CLAUDE_DIR="$HOME/.claude"
AGENTS_SKILLS="$HOME/.agents/skills"

log() { printf '\033[1;36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!! \033[0m %s\n' "$*"; }

# --- Locate the repo: run-in-place if SKILL dirs are next to us, else clone ---
SRC="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
if [ -z "$SRC" ] || [ ! -f "$SRC/CLAUDE.md" ]; then
    SRC="${TMPDIR:-/tmp}/pwguler-skills-$$"
    log "cloning $REPO_URL"
    git clone --depth 1 "$REPO_URL" "$SRC"
    CLEANUP="$SRC"
fi

# --- 1) Skills -> a home skills dir (every dir with a SKILL.md, one tier deep) ---
install_skills() {
    local dest="$1"
    mkdir -p "$dest"
    log "installing skills -> $dest"
    count=0
    for d in "$SRC"/*/ "$SRC"/*/*/; do
        [ -f "${d}SKILL.md" ] || continue
        name="$(basename "$d")"
        target="$dest/$name"
        # Guard: if the repo was cloned directly into the destination, the
        # source IS the destination: skip the rm/cp (it would delete then copy nothing).
        if [ "${d%/}" -ef "$target" ] 2>/dev/null; then
            count=$((count + 1))
            continue
        fi
        rm -rf "${target:?}"
        cp -r "$d" "$target"
        count=$((count + 1))
    done
    log "  $count skills installed"

    # Prune: the repo is the source of truth. Any skill dir living in the
    # destination without a counterpart in the repo is stale (renamed or
    # removed) and gets deleted, with a warning per removal. Only dirs that
    # contain a SKILL.md are considered; loose files and non-skill dirs are left alone.
    local repo_skills=" "
    for d in "$SRC"/*/ "$SRC"/*/*/; do
        [ -f "${d}SKILL.md" ] || continue
        repo_skills="$repo_skills$(basename "$d") "
    done
    for d in "$dest"/*/; do
        [ -f "${d}SKILL.md" ] || continue
        name="$(basename "$d")"
        case "$repo_skills" in
            *" $name "*) ;;
            *)
                warn "removing stale skill: $name (not in repo)"
                rm -rf "${d:?}"
                ;;
        esac
    done
}

install_skills "$AGENTS_SKILLS"

# --- 1b) Flatten a legacy nested layout (~/.agents/skills/skills/<name>).
# Skills not in the repo (locally added ones) move up a level; repo skills are
# already freshly installed flat, so the nested copy just goes.
if [ -d "$AGENTS_SKILLS/skills" ]; then
    log "flattening $AGENTS_SKILLS/skills"
    for d in "$AGENTS_SKILLS/skills"/*/; do
        [ -f "${d}SKILL.md" ] || continue
        name="$(basename "$d")"
        if [ ! -d "$AGENTS_SKILLS/$name" ]; then
            mv "$d" "$AGENTS_SKILLS/$name"
            warn "kept local skill: $name"
        else
            rm -rf "${d:?}"
        fi
    done
    rmdir "$AGENTS_SKILLS/skills" 2>/dev/null || true
fi

# --- 2) CLAUDE.md (+ RTK.md if present) -> ~/.claude/ (backup existing) ---
for f in CLAUDE.md RTK.md; do
    [ -f "$SRC/$f" ] || continue
    [ -f "$CLAUDE_DIR/$f" ] && cp "$CLAUDE_DIR/$f" "$CLAUDE_DIR/$f.bak.$(date +%s)"
    cp "$SRC/$f" "$CLAUDE_DIR/$f"
    log "deployed $f"
done

# --- 2a) codex: point its global instructions at ~/.claude via symlinks so
# CLAUDE.md stays the single source of truth. codex reads ~/.codex/AGENTS.md
# and resolves @-references relative to that file's directory, so RTK.md
# needs a symlink there too.
CODEX_DIR="$HOME/.codex"
link_codex() { # $1=name $2=source
    local name="$1" src="$2"
    local target="$CODEX_DIR/$name"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        cp "$target" "$target.bak.$(date +%s)"
        warn "backed up existing $target"
    fi
    ln -sfn "$src" "$target"
    log "linked $target -> $src"
}
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    mkdir -p "$CODEX_DIR"
    link_codex AGENTS.md "$CLAUDE_DIR/CLAUDE.md"
    if [ -f "$CLAUDE_DIR/RTK.md" ]; then
        link_codex RTK.md "$CLAUDE_DIR/RTK.md"
    fi
fi

# --- 2b) opencode: gate user-only skills (deep, which-skill) behind user
# approval. opencode ignores disable-model-invocation, so enforce it via
# permission rules in the global config.
OPENCODE_CONFIG="$HOME/.config/opencode/opencode.json"
if command -v jq >/dev/null 2>&1; then
    if [ ! -f "$OPENCODE_CONFIG" ]; then
        mkdir -p "$(dirname "$OPENCODE_CONFIG")"
        printf '%s\n' '{"$schema":"https://opencode.ai/config.json","permission":{"skill":{"deep":"ask","which-skill":"ask"}}}' > "$OPENCODE_CONFIG"
    else
        jq '.permission.skill.deep = "ask" | .permission.skill["which-skill"] = "ask"' "$OPENCODE_CONFIG" > "$OPENCODE_CONFIG.tmp" \
            && mv "$OPENCODE_CONFIG.tmp" "$OPENCODE_CONFIG"
    fi
    log "opencode: deep and which-skill gated behind user approval (permission.skill)"
else
    warn "jq not found; add to $OPENCODE_CONFIG: \"permission\": {\"skill\": {\"deep\": \"ask\", \"which-skill\": \"ask\"}}"
fi

# --- 3) rtk: install binary + wire the Claude Code hook ---
if command -v rtk >/dev/null 2>&1; then
    log "rtk already installed ($(rtk --version 2>/dev/null || echo '?'))"
else
    log "installing rtk"
    curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/master/install.sh | sh
fi
if command -v rtk >/dev/null 2>&1; then
    log "wiring rtk Claude Code hook (rtk init -g --auto-patch)"
    rtk init -g --auto-patch || warn "rtk init failed; run: rtk init -g --auto-patch"
else
    warn "rtk not on PATH after install; add ~/.local/bin to PATH, then: rtk init -g"
fi

[ -n "${CLEANUP:-}" ] && rm -rf "$CLEANUP"
log "done. Restart Claude Code to load skills."
