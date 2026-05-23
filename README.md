# agent-skills

A curated collection of AI agent skills for day-to-day software development. Originally from the [Cursor team's public plugin kit](https://github.com/cursor/plugins/tree/main/cursor-team-kit), packaged here for easy installation across agents.

## Skills

| Skill | Description |
|---|---|
| `thermo-nuclear-code-quality-review` | Extremely strict code review: deletes complexity instead of moving it, blocks files over 1k lines, rejects PRs that work but make code messier |
| `deslop` | Removes AI-generated slop — thin wrappers, leaked logic, redundant indirection introduced by AI coding assistants |
| `verify-this` | Verifies a claim with fresh local evidence: captures baseline and treatment, compares artifacts, returns VERIFIED / NOT VERIFIED / INCONCLUSIVE |
| `workflow-from-chats` | Extracts durable working preferences from recent agent chats and converts them into reusable skills, rules, or workflow docs |

## Installation

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/learnerLj/agent-skills/main/install.sh | bash
```

### Manual

```bash
SKILLS_DIR="$HOME/.agents/skills"
BASE="https://raw.githubusercontent.com/learnerLj/agent-skills/main/skills"

for skill in thermo-nuclear-code-quality-review deslop verify-this workflow-from-chats; do
  mkdir -p "$SKILLS_DIR/$skill"
  curl -fsSL "$BASE/$skill/SKILL.md" -o "$SKILLS_DIR/$skill/SKILL.md"
done
```

Skills are installed to `~/.agents/skills/` — the shared path that Codex and Claude Code both scan automatically.

## Platform support

| Agent | Status | Notes |
|---|---|---|
| [Codex](https://codex.com) | Supported | Auto-scans `~/.agents/skills/` |
| [Claude Code](https://claude.ai/code) | Supported | Auto-scans `~/.agents/skills/` |
| [Factory Droid](https://factory.ai) | Supported | Auto-scans `~/.agents/skills/` |

## Usage

Once installed, invoke skills by name in your agent session:

```
/thermo-nuclear-code-quality-review
/deslop
/verify-this
/workflow-from-chats
```

Or describe the intent in natural language — the agent will match and load the appropriate skill automatically.

## Credits

Skills sourced from [cursor/plugins](https://github.com/cursor/plugins), the Cursor team's public plugin kit.
