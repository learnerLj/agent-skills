# agent-skills

AI 编程 Agent 的 Skill 合集。

---

## Skills

| Skill | 解决什么问题 | 触发时机 | 核心机制 | 产出 |
|---|---|---|---|---|
| [`claude-code-ultracode-patch`](skills/claude-code-ultracode-patch/SKILL.md) | Claude Code 的 ultracode 模式被服务端门控锁定 | 要求解锁 ultracode、patch Claude Code 二进制、或绕过 workflow feature flag | 结构化正则匹配门控函数模板（混淆名每版变，结构模板跨版本稳定），等长替换 patch | 已 patch 的二进制 + `ULTRACODE_PATCH` 标记 |
| [`thermo-nuclear-code-quality-review`](skills/thermo-nuclear-code-quality-review/SKILL.md) | AI 写的代码能跑但越来越乱，复杂度只是被搬来搬去 | 要求严格审查、深度代码质量审计、或"用核弹级别的标准审一遍" | 10 条不可协商规则：寻找 code judo 重构点、1k 行文件硬上限、禁止 spaghetti 增长、删除复杂度而非移动它 | 逐条审查报告，带具体重构建议和删除目标 |
| [`deslop`](skills/deslop/SKILL.md) | AI 生成的薄 wrapper、多余注释、无意义的 `any` 转换、防御性检查堆砌 | 分支里有 AI 生成的 diff，或"帮我清理 AI 写的代码" | 对比 main 分支 of diff，按模式匹配 5 类 slop（多余注释、异常防御、`any` 绕过、深层嵌套、风格不一致） | 最小化的精简 diff，1-3 句总结 |
| [`verify-this`](skills/verify-this/SKILL.md) | "修好了"但没有证据，agent 自己说 PASS 就完事 | 用户说"验证一下"、"证明它能用"、"修好了吗"、"给我看证据" | 把声明改写为可证伪形式 → 捕获 baseline → 捕获 treatment → 对比原始 artifact | 唯一裁决：`VERIFIED` / `NOT VERIFIED` / `INCONCLUSIVE` + 证据文件 |
| [`make-goal`](skills/make-goal/SKILL.md) | "帮我把这个项目变好"式无效指令，agent 不知道做到什么程度算完 | 要写 goal、review goal、把 issue/PR/bug report 转为可执行任务 | 6 步合约：单一目标 → 真实上下文 → 硬约束 → 可审计完成条件 → 新鲜验证 → 停机规则；7 个 lint profile 覆盖安全/迁移/前端/只读等场景 | `/goal` 合约（full 或 compact 格式）+ 40+ 个可复用模式库 |
| [`skill-creator`](skills/skill-creator/SKILL.md) | 自动化创建新技能，演进并优化现有技能的触发描述与执行质量 | 想要开发/创建新技能、测试技能表现、进行触发率打分、或自动优化技能 YAML 描述 | 通过 `run_loop.py` 评估测试集，在后台拉起 `claude -p` 命令，通过流式 JSON 意图监听技术实时判定触发，由 LLM 错题本定向改写，配合 Train/Test 隔离防止描述过拟合 | 100% 触发准确度的技能描述 frontmatter 、跑分 HTML 报告与评分汇总数据 |

---

## 安装

把下面的 prompt 粘贴到你的 AI agent（Codex、Claude Code、Cursor 或任何编程助手）里：

```
Install the following agent skills from https://github.com/learnerLj/agent-skills
by downloading each SKILL.md into the correct skills directory.

Skills: claude-code-ultracode-patch, thermo-nuclear-code-quality-review, deslop, verify-this, make-goal, skill-creator.

Base URL for raw files:
https://raw.githubusercontent.com/learnerLj/agent-skills/main/skills/{skill-name}/SKILL.md

For make-goal, also download the references/ and scripts/ directories:
https://raw.githubusercontent.com/learnerLj/agent-skills/main/skills/make-goal/references/
https://raw.githubusercontent.com/learnerLj/agent-skills/main/skills/make-goal/scripts/

For skill-creator, also download the agents/, assets/, eval-viewer/, references/ and scripts/ directories:
https://raw.githubusercontent.com/learnerLj/agent-skills/main/skills/skill-creator/agents/
https://raw.githubusercontent.com/learnerLj/agent-skills/main/skills/skill-creator/assets/
https://raw.githubusercontent.com/learnerLj/agent-skills/main/skills/skill-creator/eval-viewer/
https://raw.githubusercontent.com/learnerLj/agent-skills/main/skills/skill-creator/references/
https://raw.githubusercontent.com/learnerLj/agent-skills/main/skills/skill-creator/scripts/

Platform paths:
- Codex / Factory Droid: ~/.agents/skills/
- Claude Code: ~/.claude/skills/
- Cursor: ~/.cursor/skills/ or project .cursor/rules/
```

---

## 致谢

原始 skills 来自 Cursor 团队的 [cursor/plugins](https://github.com/cursor/plugins) 仓库。
`make-goal` 为 agent 驱动的开发工作流而建。
