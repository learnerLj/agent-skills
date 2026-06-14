---
name: dedaub-decompiler
description: |
  Decompile EVM smart contracts via the Dedaub CLI tool (`dedaub-pp-cli`, also called `printing-press`). Use when the user asks to decompile bytecode, fetch Solidity pseudo-code, Yul source, or AI-reconstructed source, or decompiled JSON from Dedaub for any EVM contract address. Covers reverse-engineering contract logic, querying Dedaub endpoints, and pulling source reconstructions on Ethereum, Base, Arbitrum, Optimism, Polygon, and BNB Chain. Always invoke when the user mentions `dedaub-pp-cli`, `printing-press client`, `printing-press`, or Dedaub decompilation.
title: Dedaub 反编译工具 CLI 技能
---

# Dedaub Decompiler CLI Skill

使用本地 Go 语言命令行工具（`dedaub-pp-cli`）请求 Dedaub 数据端点，高速拉取 EVM 智能合约的 Solidity 伪代码、Yul 格式反编译代码以及 AI 源码重建数据。

## 1. Prerequisites

* **离线会话凭证（Cookie）**：
  必须在本地 `~/.config/dedaub-pp-cli/config.toml` 中配置有效的 `session-token`，以便客户端接管已登录会话。
* **CLI 二进制客户端**：
  使用已经编译完成的本地客户端二进制：
  `/Users/mike/projects/dedaub-pp-cli/bin/dedaub-pp-cli`

## 2. Quick Start

调用命令时需传入合约地址与网络标识，附加 `--plain` 参数以输出纯 JSON 格式。

### 2.1 拉取常规 Solidity 伪代码
针对已有反编译 Solidity 伪代码的普通合约：
```bash
/Users/mike/projects/dedaub-pp-cli/bin/dedaub-pp-cli next get-decompiled.json <address> <network> --plain > /tmp/decompiled.json
```

### 2.2 拉取 Yul 格式反编译代码
针对没有常规 Solidity 代码、仅有 Yul 表示的复杂合约（如 `0x24c0e9e2f260e19de839aab785c3ce19cb978c25`）：
```bash
/Users/mike/projects/dedaub-pp-cli/bin/dedaub-pp-cli next get-decompiled-yul.json <address> <network> --plain > /tmp/decompiled_yul.json
```

### 2.3 拉取 AI 重构源码
获取经过 AI 重大命名和结构修复的高物理语义源码：
```bash
/Users/mike/projects/dedaub-pp-cli/bin/dedaub-pp-cli next get-ai-reconstruction.json <address> <network> --plain > /tmp/ai_reconstruction.json
```

## 3. Supported Networks

在 `<network>` 参数中传递 Dedaub 原生收录的网络标识：
* `ethereum` (以太坊主网)
* `base` (Base 网络)
* `arbitrum` (Arbitrum)
* `optimism` (Optimism)
* `polygon` (Polygon)
* `binance` (BNB Chain) 等

## 4. Troubleshooting

| 现象 | 原因分析 | 解决方案 |
| :--- | :--- | :--- |
| 返回 308 Permanent Redirect，Payload 无内容 | Next.js 路由对十六进制地址大小写敏感，大写字母会导致 Node.js 强制重定向 | **在执行 CLI 命令前，必须首先在本地将以太坊十六进制地址统一转换为全小写格式**。 |
| 报 400 Bad Request 错误 | `session-token` 凭证与伪造指纹过大，超出了 Dedaub Nginx 缓冲区上限 | 确认 `client.go` 中已剔除 `surf/impersonate` 指纹伪造，仅发送精简 UA/Referer。 |
| 返回 404 错误 | 1. 目标合约在该链上不存在；2. 链标识写错（如将 `binance` 错写为 `bsc`） | 1. 确认合约正确部署；2. 修正为 Dedaub 原生 Network slug 标识。 |

---

## 5. Further Reading

* 使用 Printing Press 构建客户端的核心机制（参考本地文档：`reference/tech/web-to-cli/printing-press-core-concepts.md`）
* Dedaub CLI 的环境解密与修补实践（参考本地文档：`reference/tech/web-to-cli/dedaub-decompiler-cli-practice.md`）
