#!/usr/bin/env bash
# Iterative self-review loop for Claude Code, driven by REVIEW_CHECKLIST.md.
#
# Run this from your project root (where REVIEW_CHECKLIST.md lives, and
# where `claude` works). Requires the `claude` CLI already set up.
#
# Usage: ./run-review-loop.sh [max_iterations]
# Default cap is 8 — see the note below before raising it.

set -euo pipefail

MAX_ITER="${1:-8}"
LOG_FILE="REVIEW_LOG.md"

if [ ! -f "REVIEW_CHECKLIST.md" ]; then
  echo "REVIEW_CHECKLIST.md not found in $(pwd). Put it in your project root first."
  exit 1
fi

if [ ! -f "$LOG_FILE" ]; then
  echo "# Review Log" > "$LOG_FILE"
  echo "" >> "$LOG_FILE"
fi

# --- GitHub safety: remove any remotes for the duration of the loop, so
# even if a run attempts `git push`, there's nothing to push to. Restored
# on exit (normal finish, error, or Ctrl+C) via the trap below.
SAVED_REMOTES_FILE="$(mktemp)"
git remote -v 2>/dev/null | awk '{print $1, $2}' | sort -u > "$SAVED_REMOTES_FILE" || true

restore_remotes() {
  if [ -s "$SAVED_REMOTES_FILE" ]; then
    while read -r name url; do
      [ -z "$name" ] && continue
      git remote add "$name" "$url" 2>/dev/null || git remote set-url "$name" "$url" 2>/dev/null || true
    done < "$SAVED_REMOTES_FILE"
    echo "Git remote(s) restored: $(git remote -v | tr '\n' ' ')"
  fi
  rm -f "$SAVED_REMOTES_FILE"
}
trap restore_remotes EXIT

if [ -s "$SAVED_REMOTES_FILE" ]; then
  while read -r name _; do
    [ -z "$name" ] && continue
    git remote remove "$name" 2>/dev/null || true
  done < "$SAVED_REMOTES_FILE"
  echo "Git remote(s) temporarily removed for this run — commits stay local until you push yourself."
fi

for i in $(seq 1 "$MAX_ITER"); do
  echo ""
  echo "=== Iteration $i / $MAX_ITER ==="

  # Snapshot the diff before this round, to detect when changes go quiet.
  BEFORE_HASH=$(git diff --stat 2>/dev/null | md5sum | cut -d' ' -f1 || echo "nogit")

  PROMPT="You're running iteration $i of an automated review loop on this
portfolio site. Read REVIEW_CHECKLIST.md and REVIEW_LOG.md (if it has
entries) to see what's already been checked off and what hasn't.

Pick the SINGLE highest-priority unchecked item from the checklist —
prioritize structure/content items over polish items on early iterations.

IMPORTANT — identity-dependent values (GitHub username, LeetCode username,
resume link, any other personal ID) are NOT available yet and will be
supplied later. Never block on these, never invent a real-looking username,
and never hardcode a placeholder directly inside a component. Instead:
route every such value through a single config file (e.g. site.config.ts /
config.json), set to an obvious placeholder (e.g. \"YOUR_GITHUB_USERNAME\"),
and build each dependent feature (GitHub graph, LeetCode graph, etc.) so it
renders a clean, intentional-looking placeholder state when the config
still holds that placeholder — not a broken image, blank space, or console
error. Keep (or create) a SETUP.md that lists every placeholder in the
config file and what real value it needs later. The goal: when real IDs
are dropped into the config later, nothing else needs to change.

Implement the picked item fully, following the above where relevant. Then:
1. Start the local dev server if it isn't running, and take a screenshot
   of the affected page/section (use whatever browser tooling you have) to
   verify it actually rendered correctly and matches the checklist intent.
2. Self-grade the change against the specific checklist bullet: did it
   actually satisfy it, partially, or not at all? Be honest and critical —
   don't mark something done if it's a rough approximation.
3. Append a short entry to REVIEW_LOG.md: iteration number, which checklist
   item, what you changed, the self-grade, and one sentence on what (if
   anything) still needs follow-up.
4. If you completed the item, check its box in REVIEW_CHECKLIST.md.
5. Commit the change locally with a clear commit message referencing the
   checklist item.

NEVER push, fetch from, or otherwise contact any git remote or GitHub —
no 'git push', 'git fetch', 'git pull', no 'gh' CLI commands (repo create,
pr create, etc.), no GitHub API calls. Local commits only. This project's
remote has been intentionally detached for this run; do not attempt to
re-add one. If you believe a remote action is genuinely needed, stop and
say so in REVIEW_LOG.md instead of doing it.

Do not attempt multiple checklist items in one iteration. Do not restyle
or 'improve' anything not on the checklist. If every item is already
checked, instead do a fresh critical pass: re-open the two most
content-heavy pages, re-check them against the psychological-principles
section specifically, and log honestly whether anything regressed.

BE MORE CREATIVE THAN YOUR DEFAULT. Earlier rounds tended to play it safe —
technically correct, visually flat, minimal deviation from a generic
template. When you pick a 'Visual polish / creative beautification' item,
actually push: try an unusual layout, a bold typographic moment, a hover/
scroll interaction, an asymmetric composition — something a generic
template wouldn't produce — while staying inside the established color
palette, fonts, and spacing tokens (bolder USE of the existing design
language, not a new one). If a change feels safe/expected, that's a signal
to go further, not a signal it's done. When working on the tech stack
section or any icon/logo, actually download real SVG icon assets into the
project (e.g. from simpleicons.org, or 'npm install simple-icons') —
prefer monochrome/black-and-white versions recolored via CSS
(fill: currentColor) so they read as one consistent visual system rather
than mismatched brand-colored logos. Never leave icons as emoji or plain
text placeholders when a real icon asset is what the checklist calls for."

  if [ "$i" -eq 1 ]; then
    claude -p "$PROMPT" --dangerously-skip-permissions
  else
    claude --continue -p "$PROMPT" --dangerously-skip-permissions
  fi

  AFTER_HASH=$(git diff --stat 2>/dev/null | md5sum | cut -d' ' -f1 || echo "nogit")

  # If nothing changed AND the checklist is fully checked, stop early.
  if [ "$BEFORE_HASH" = "$AFTER_HASH" ]; then
    UNCHECKED=$(grep -c '\[ \]' REVIEW_CHECKLIST.md || true)
    if [ "$UNCHECKED" -eq 0 ]; then
      echo "Checklist fully satisfied and no changes made this round — stopping early."
      break
    fi
  fi
done

echo ""
echo "Loop finished. Review REVIEW_LOG.md for a full history of what changed."