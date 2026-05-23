#!/usr/bin/env bash
set -e

BASE_URL="https://raw.githubusercontent.com/learnerLj/agent-skills/main/skills"

SKILLS=(
  thermo-nuclear-code-quality-review
  deslop
  verify-this
  workflow-from-chats
)

install_skills() {
  local dir="$1"
  echo "Installing to $dir ..."
  for skill in "${SKILLS[@]}"; do
    mkdir -p "$dir/$skill"
    curl -fsSL "$BASE_URL/$skill/SKILL.md" -o "$dir/$skill/SKILL.md"
    echo "  installed: $skill"
  done
}

# Codex / Factory Droid
install_skills "$HOME/.agents/skills"

# Claude Code (uses a separate path)
if [ -d "$HOME/.claude" ]; then
  install_skills "$HOME/.claude/skills"
fi

echo "Done. Restart your agent session to activate."
