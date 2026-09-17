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
5. Commit the change with a clear commit message referencing the checklist
   item.

Do not attempt multiple checklist items in one iteration. Do not restyle
or 'improve' anything not on the checklist. If every item is already
checked, instead do a fresh critical pass: re-open the two most
content-heavy pages, re-check them against the psychological-principles
section specifically, and log honestly whether anything regressed."

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