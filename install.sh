#!/usr/bin/env bash
set -e

SKILLS_DIR="${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}"
BASE_URL="https://raw.githubusercontent.com/learnerLj/agent-skills/main/skills"

SKILLS=(
  thermo-nuclear-code-quality-review
  deslop
  verify-this
  workflow-from-chats
)

echo "Installing agent skills to $SKILLS_DIR ..."

for skill in "${SKILLS[@]}"; do
  mkdir -p "$SKILLS_DIR/$skill"
  curl -fsSL "$BASE_URL/$skill/SKILL.md" -o "$SKILLS_DIR/$skill/SKILL.md"
  echo "  installed: $skill"
done

echo "Done. Restart your agent session to activate."
