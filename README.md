# agent-skills

**中文介绍：** 这是一份为 AI 编程 Agent 精选的 Skill 合集，来源于 [Cursor 团队公开的插件仓库](https://github.com/cursor/plugins/tree/main/cursor-team-kit)。核心理念：**复杂度只能被消灭，不能被转移**。这几个 Skill 专门对抗 AI 辅助编程带来的常见问题——薄 wrapper 堆积、逻辑泄漏、能跑但越来越乱的代码。

---

A curated collection of AI agent skills for software development, sourced from the [Cursor team's public plugin kit](https://github.com/cursor/plugins/tree/main/cursor-team-kit).

## Skills

| Skill | Description |
|---|---|
| `thermo-nuclear-code-quality-review` | Extremely strict code review: deletes complexity instead of moving it, blocks files over 1k lines, rejects PRs that work but make code messier |
| `deslop` | Removes AI-generated slop — thin wrappers, leaked logic, pointless indirection |
| `verify-this` | Verifies a claim with local evidence, returns VERIFIED / NOT VERIFIED / INCONCLUSIVE |
| `workflow-from-chats` | Extracts durable working preferences from recent agent chats into reusable skills or rules |

## Installation

Copy this prompt into your AI agent (Codex, Claude Code, or any coding assistant):

```
Install the following agent skills from https://github.com/learnerLj/agent-skills by downloading each SKILL.md into the correct skills directory. Skills: thermo-nuclear-code-quality-review, deslop, verify-this, workflow-from-chats. Use ~/.agents/skills/ for Codex and Factory Droid, ~/.claude/skills/ for Claude Code. Base URL for raw files: https://raw.githubusercontent.com/learnerLj/agent-skills/main/skills/{skill-name}/SKILL.md
```

## Platform Support

| Agent | Skills path |
|---|---|
| [Codex](https://codex.com) | `~/.agents/skills/` |
| [Factory Droid](https://factory.ai) | `~/.agents/skills/` |
| [Claude Code](https://claude.ai/code) | `~/.claude/skills/` |

## Credits

Skills sourced from [cursor/plugins](https://github.com/cursor/plugins) by the Cursor team.
