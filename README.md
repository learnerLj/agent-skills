# agent-skills

AI 编程 Agent 的 Skill 合集。对抗 AI 辅助编程的常见病：薄 wrapper 堆积、逻辑泄漏、能跑但越来越乱的代码、以及"帮我把这个项目变好"式的无效指令。

核心理念：**复杂度只能被消灭，不能被转移。**

---

## Skills

| Skill | 作用 |
|---|---|
| [`thermo-nuclear-code-quality-review`](skills/thermo-nuclear-code-quality-review/SKILL.md) | 极严格代码审查：删除复杂度而不是移动它，1k+ 行文件直接打回，能跑但让代码更乱的 PR 直接拒绝 |
| [`deslop`](skills/deslop/SKILL.md) | 清除 AI 生成的代码垃圾——薄 wrapper、泄漏的逻辑、无意义的间接层 |
| [`verify-this`](skills/verify-this/SKILL.md) | 用本地证据验证声明，返回 VERIFIED / NOT VERIFIED / INCONCLUSIVE |
| [`workflow-from-chats`](skills/workflow-from-chats/SKILL.md) | 从最近的 agent 对话中提取持久的工作偏好，转化为可复用的 skill 或规则 |
| [`make-goal`](skills/make-goal/SKILL.md) | 把模糊的工程意图转化为可执行的 `/goal` 任务契约——一个目标、硬约束、可审计的验证、和停机规则 |

---

## make-goal

这个 skill 比较特殊，自带工具链：

- **lint** — 检查 goal 合约的结构性缺陷（必需字段、模糊语言、缺失的安全约束）
- **evals** — 17 个 fixture 测试（8 个 pass、5 个 fail、4 个 skill 自检），覆盖 auth、migration、XSS、read-only、launch-readiness 场景
- **references** — 合约模板、模式选择指南、质量标准、40+ 个 source-backed 和 seed 模式

```bash
# lint 一个 goal 文件
python3 skills/make-goal/scripts/lint_goal.py my-goal.md

# 用特定 profile lint
python3 skills/make-goal/scripts/lint_goal.py my-goal.md --profile data-migration

# 跑 evals
python3 skills/make-goal/scripts/run_evals.py
```

---

## 安装

把下面的 prompt 粘贴到你的 AI agent（Codex、Claude Code、Cursor 或任何编程助手）里：

```
Install the following agent skills from https://github.com/learnerLj/agent-skills
by downloading each SKILL.md into the correct skills directory.

Skills: thermo-nuclear-code-quality-review, deslop, verify-this, workflow-from-chats, make-goal.

Base URL for raw files:
https://raw.githubusercontent.com/learnerLj/agent-skills/main/skills/{skill-name}/SKILL.md

For make-goal, also download the references/ and scripts/ directories:
https://raw.githubusercontent.com/learnerLj/agent-skills/main/skills/make-goal/references/
https://raw.githubusercontent.com/learnerLj/agent-skills/main/skills/make-goal/scripts/

Platform paths:
- Codex / Factory Droid: ~/.agents/skills/
- Claude Code: ~/.claude/skills/
- Cursor: ~/.cursor/skills/ or project .cursor/rules/
```

---

## 平台支持

| Agent | Skills 路径 |
|---|---|
| [Codex](https://codex.com) | `~/.agents/skills/` |
| [Factory Droid](https://factory.ai) | `~/.agents/skills/` |
| [Claude Code](https://claude.ai/code) | `~/.claude/skills/` |
| [Cursor](https://cursor.com) | `~/.cursor/skills/` 或 `.cursor/rules` |
| [Hermes Agent](https://hermes-agent.nousresearch.com) | `~/.hermes/skills/` |

---

## 致谢

原始 skills 来自 Cursor 团队的 [cursor/plugins](https://github.com/cursor/plugins) 仓库。
`make-goal` 为 agent 驱动的开发工作流而建。
