# agent-skills

| Skill | 解决什么问题 | 触发时机 | 核心机制 | 产出 |
|---|---|---|---|---|
| `claude-code-ultracode-patch` | Claude Code 的 ultracode 模式被服务端门控锁定 | 要求解锁 ultracode、patch 二进制、绕过 workflow feature flag | 结构化正则匹配门控函数模板，等长替换 patch | 已 patch 的二进制 + `ULTRACODE_PATCH` 标记 |
| `thermo-nuclear-code-quality-review` | AI 写的代码能跑但越来越乱 | 要求严格审查、深度代码质量审计 | 10 条不可协商规则：code judo 重构点、1k 行硬上限、删除复杂度而非移动 | 逐条审查报告 + 重构建议 |
| `deslop` | AI 生成的薄 wrapper、多余注释、any 绕过 | 分支里有 AI 生成的 diff | 对比 main 分支 diff，匹配 5 类 slop | 精简 diff + 总结 |
| `verify-this` | "修好了"但没有证据 | 用户说"验证一下"、"给我看证据" | 声明改写为可证伪形式 → baseline → treatment → 对比 | `VERIFIED` / `NOT VERIFIED` / `INCONCLUSIVE` |
| `make-goal` | "帮我把这个项目变好"式无效指令 | 要写 goal、review goal、转 issue 为任务 | 6 步合约 + 7 个 lint profile | `/goal` 合约 + 模式库 |
| `skill-creator` | 自动化创建/优化技能 | 想开发新技能、测试触发率 | `run_loop.py` 评估 + LLM 错题本改写 | 100% 触发准确度的描述 + 报告 |

安装路径：
- Claude Code: `~/.claude/skills/`
- Codex / Factory Droid: `~/.agents/skills/`
- Cursor: `~/.cursor/skills/` 或 `.cursor/rules`

Raw base URL: `https://raw.githubusercontent.com/learnerLj/agent-skills/main/skills/{skill-name}/SKILL.md`
