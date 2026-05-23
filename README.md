# agent-skills

**中文介绍：** 这是一份为 AI 编程 Agent 精选的 Skill 合集，来源于 [Cursor 团队公开的插件仓库](https://github.com/cursor/plugins/tree/main/cursor-team-kit)。一行命令安装，在 Codex、Claude Code 等主流 AI 编程工具里直接使用。

核心理念：**复杂度只能被消灭，不能被转移**。这几个 Skill 专门对抗 AI 辅助编程带来的常见问题——薄 wrapper 堆积、逻辑泄漏、能跑但越来越乱的代码。

---

A curated collection of AI agent skills for software development, sourced from the [Cursor team's public plugin kit](https://github.com/cursor/plugins/tree/main/cursor-team-kit).

## Skills

| Skill | 说明 | Description |
|---|---|---|
| `thermo-nuclear-code-quality-review` | 核弹级代码审查：删复杂度而非转移，封锁超 1k 行文件，拒绝「能跑但更乱」的 PR | Extremely strict code review: deletes complexity, blocks files over 1k lines, rejects PRs that make code messier |
| `deslop` | 清理 AI 生成的烂代码：薄 wrapper、泄漏逻辑、无用间接层 | Removes AI-generated slop — thin wrappers, leaked logic, pointless indirection |
| `verify-this` | 用本地证据验证一个主张，返回 VERIFIED / NOT VERIFIED / INCONCLUSIVE | Verifies a claim with local evidence, not just reasoning |
| `workflow-from-chats` | 从最近的对话提炼持久工作规则，沉淀成 Skill 或 Rule 文件 | Extracts durable working preferences from recent chats into reusable skills or rules |

## 安装 / Installation

### 一键安装（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/learnerLj/agent-skills/main/install.sh | bash
```

自动安装到 `~/.agents/skills/`（Codex / Factory Droid）和 `~/.claude/skills/`（Claude Code）。

### 手动安装

**Codex / Factory Droid：**

```bash
BASE="https://raw.githubusercontent.com/learnerLj/agent-skills/main/skills"
for skill in thermo-nuclear-code-quality-review deslop verify-this workflow-from-chats; do
  mkdir -p ~/.agents/skills/$skill
  curl -fsSL "$BASE/$skill/SKILL.md" -o ~/.agents/skills/$skill/SKILL.md
done
```

**Claude Code：**

```bash
BASE="https://raw.githubusercontent.com/learnerLj/agent-skills/main/skills"
for skill in thermo-nuclear-code-quality-review deslop verify-this workflow-from-chats; do
  mkdir -p ~/.claude/skills/$skill
  curl -fsSL "$BASE/$skill/SKILL.md" -o ~/.claude/skills/$skill/SKILL.md
done
```

## 平台支持 / Platform Support

| Agent | Path | Status |
|---|---|---|
| [Codex](https://codex.com) | `~/.agents/skills/` | Supported |
| [Factory Droid](https://factory.ai) | `~/.agents/skills/` | Supported |
| [Claude Code](https://claude.ai/code) | `~/.claude/skills/` | Supported |

## 使用 / Usage

安装后在 Agent 会话里直接调用：

```
/thermo-nuclear-code-quality-review
/deslop
/verify-this
/workflow-from-chats
```

也可以用自然语言描述意图，Agent 会自动匹配对应 Skill。

## Credits

Skills sourced from [cursor/plugins](https://github.com/cursor/plugins) by the Cursor team.
