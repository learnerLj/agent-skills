---
name: claude-code-ultracode-patch
description: 定位并 patch Claude Code Bun 二进制中的服务端门控结构（workflow 开关、ultracode 准入门）。版本无关——用结构化正则而非硬编码字节特征。支持动态分析新版本的门控变化。当用户要求解锁 ultracode、patch Claude Code 二进制、或绕过 workflow feature flag 时使用。
---

# Claude Code ultracode 二进制逆向与 patch 技能

强制开启 Claude Code 的 `ultracode` effort 模式（xhigh 推理 + 动态工作流编排）。通过 patch Bun 编译的单文件二进制实现。

**核心思路**：混淆函数名每次编译都变，但门控逻辑的结构模板跨版本稳定。本技能用正则匹配结构，不硬编码字节。当结构本身变化时，本技能也提供了从零逆向的方法。

## 适用场景

- 用户要求在任意版本的 Claude Code 上解锁 ultracode
- 已有 patch 脚本因字节特征不匹配新版本而失效
- 需要验证某个二进制的 workflow/ultracode 是否被门控
- 用户询问 Claude Code effort level 或 feature flag 的内部机制

## 前置条件

- `python3` 可用
- macOS：`codesign`（随 Xcode CLT 提供）
- Claude Code 已安装（二进制存在于磁盘）

---

## 阶段一：定位与备份

### 1.1 定位二进制

```bash
BIN="$(readlink -f "$(command -v claude)" 2>/dev/null || \
  node -e 'console.log(require("fs").realpathSync(require("child_process").execSync("which claude").toString().trim()))')"
PKG="$(dirname "$BIN")/../package.json"
VERSION="$(node -e "try{console.log(require('$PKG').version)}catch(e){console.log('unknown')}")"
echo "Binary: $BIN (version $VERSION)"
```

断言：二进制存在，是 Mach-O（macOS）或 ELF（Linux）可执行文件。

### 1.2 备份

```bash
BACKUP_DIR="$HOME/.claude/backups"
mkdir -p "$BACKUP_DIR"
BACKUP="$BACKUP_DIR/claude.exe.$VERSION.orig"
if [ ! -f "$BACKUP" ]; then
  cp "$BIN" "$BACKUP"
  echo "已备份 -> $BACKUP"
else
  echo "备份已存在 -> $BACKUP"
fi
```

---

## 阶段二：结构化定位门控函数

### 2.1 已知模板快速匹配

如果版本的结构模板未变（只是函数名变了），直接用正则匹配：

```python
import re, sys

data = open("PATH_TO_BINARY", "rb").read()

# 模板 1：4 步 workflow 开关
# function X(){if(Y())return!1;if(!Z())return!1;let{available:H,defaultOn:_}=W();if(!H)return!1;return V()??_}
wf_pattern = rb'function (\w+)\(\)\{if\((\w+)\(\)\)return!1;if\(!(\w+)\(\)\)return!1;let\{available:\w,defaultOn:\w\}=(\w+)\(\);if\(!\w\)return!1;return (\w+)\(\)\?\?\w\}'
wf_match = re.search(wf_pattern, data)

if wf_match:
    wf_name     = wf_match.group(1)
    disable_fn  = wf_match.group(2)
    allow_fn    = wf_match.group(3)
    cache_fn    = wf_match.group(4)
    fallback_fn = wf_match.group(5)
    print(f"[命中] workflow 开关: {wf_name}()")
    print(f"  显式禁用: {disable_fn}()")
    print(f"  允许标志: {allow_fn}()")
    print(f"  缓存层:   {cache_fn}()")
    print(f"  默认回退: {fallback_fn}()")

    # 模板 2：ultracode 准入门（依赖 workflow 开关名）
    gate_pattern = rb'function (\w+)\(H\)\{return ' + re.escape(wf_name) + rb'\(\)&&\(H===void 0\|\|(\w+)\(H\)\)\}'
    gate_match = re.search(gate_pattern, data)
    if gate_match:
        gate_name = gate_match.group(1)
        model_fn  = gate_match.group(2)
        print(f"[命中] ultracode 准入门: {gate_name}()")
        print(f"  模型检查: {model_fn}()")
    else:
        print("[警告] 找到 workflow 开关但找不到 ultracode 准入门，结构可能已变")
        gate_match = None
else:
    print("[未命中] 已知模板不匹配，进入动态分析模式")
    wf_match = None
    gate_match = None
```

### 2.2 交叉验证（辅助确认）

这些字符串不被混淆，可作为稳定锚点：

```python
anchors = [
    (b'Ultracode needs dynamic workflows enabled', 'ultracode 错误消息'),
    (b'Set effort level to ultracode',              'ultracode 成功消息'),
    (b'tengu_workflows_enabled',                    'GrowthBook workflow flag'),
    (b'allow_workflows',                            'GrowthBook allow flag'),
    (b'CLAUDE_CODE_DISABLE_WORKFLOWS',              '环境变量禁用标志'),
    (b'CLAUDE_CODE_WORKFLOWS',                      '环境变量 workflow 开关'),
    (b'disableWorkflows',                           'settings 禁用字段'),
]
for needle, desc in anchors:
    idx = data.find(needle)
    print(f"[锚点] {desc}: {'@ ' + str(idx) if idx != -1 else '不存在'}")
```

### 2.3 动态分析：结构模板变了怎么办

当阶段 2.1 的正则匹配失败时，说明 Anthropic 可能重构了门控逻辑。此时从**稳定锚点字符串**反向追踪调用链：

**第一步：用错误消息定位代码区域**

```python
# ultracode 错误消息是稳定的，不被混淆
error_str = b'Ultracode needs dynamic workflows enabled'
error_pos = data.find(error_str)
if error_pos == -1:
    # 可能消息文本变了，尝试更宽泛的搜索
    for m in re.finditer(rb'[Uu]ltracode.{0,50}(need|require|enabl)', data):
        print(f"  候选: @ {m.start()}: {m.group()}")

print(f"错误消息 @ {error_pos}，附近代码区域已锁定")
```

**第二步：从错误消息回溯调用者函数**

错误消息通常在 `szO()` 这类命令处理器中。向前后搜索 `function` 关键字，找到包裹它的函数定义：

```python
# 从错误消息位置向前搜索最近的 function 定义
search_start = max(0, error_pos - 5000)
region = data[search_start:error_pos]

# 找最后一个 function 定义（即包裹错误消息的函数）
for m in re.finditer(rb'function (\w+)\([^)]*\)\{', region):
    handler_name = m.group(1)
    handler_start = search_start + m.start()

print(f"命令处理器: {handler_name}()")
```

**第三步：从命令处理器中提取门控调用**

在处理器函数体内，搜索被调用的判断函数：

```python
# 提取处理器函数体（从 function 开始到匹配的 } ）
depth = 0
body_start = handler_start
i = body_start
while i < len(data):
    if data[i:i+1] == b'{': depth += 1
    elif data[i:i+1] == b'}':
        depth -= 1
        if depth == 0: break
    i += 1
handler_body = data[body_start:i+1]

# 在函数体中找 if(!XXX()) 模式——这就是门控检查
for m in re.finditer(rb'if\(!(\w+)\(\)\)', handler_body):
    gate_callee = m.group(1)
    print(f"  门控调用: {gate_callee}()")
```

**第四步：展开门控函数，分析内部逻辑**

```python
# 找到门控函数的完整定义
callee_pattern = rb'function ' + re.escape(gate_callee) + rb'\(\)\{(.{0,1000}?)\}'
callee_match = re.search(callee_pattern, data)
if callee_match:
    print(f"{gate_callee}() 函数体: {callee_match.group()[:300]}")
```

**第五步：识别 GrowthBook / feature flag 模式**

门控函数内部通常有这些模式，识别出来就能理解结构：

| 模式 | 特征 | 含义 |
|------|------|------|
| `process.env.CLAUDE_CODE_XXX` | 环境变量检查 | 本地可绕过 |
| `Z_("flag_name", ...)` 或 `N7("flag_name")` | GrowthBook flag 查询 | 服务端控制 |
| `{available: ..., defaultOn: ...}` | 可用性对象 | workflow 状态 |
| `$K() !== "pro"` 或类似 | 计划类型判断 | 按计划分级 |
| `return !1` / `return !0` | 硬编码 true/false | 可 patch 的目标 |

**第六步：确认后构建新的正则模板**

一旦理解了新的门控结构，构建对应的新正则模式，写入本 skill 的「已知模板」部分。

---

## 阶段三：执行 patch

### 3.1 等长替换

二进制是单个连续 blob，任何字节偏移都会导致后续所有内容错位。替换必须**严格等长**。

```python
MARKER = b"ULTRACODE_PATCH"

def build_replacement(original, core):
    """将 core 补齐到与 original 等长。用 /*MARKER<pad>*/} 填充。"""
    suffix = b"*/}"
    open_c = b"/*"
    fixed = len(core) + len(open_c) + len(MARKER) + len(suffix)
    pad = len(original) - fixed
    if pad < 0:
        raise ValueError(f"替换太长: 需要 {len(original)}, 固定部分 {fixed}")
    return core + open_c + MARKER + (b"-" * pad) + suffix

edits = [
    (f"{wf_name.decode()}() workflow 开关",
     wf_match.group(0),
     b"function " + wf_name + b"(){return!0"),
    (f"{gate_name.decode()}() ultracode 准入门",
     gate_match.group(0),
     b"function " + gate_name + b"(H){return!0"),
]

changed = 0
for label, orig, core in edits:
    repl = build_replacement(orig, core)
    assert len(repl) == len(orig), f"长度不匹配: {len(repl)} vs {len(orig)}"

    n = data.count(orig)
    if n == 0:
        if data.count(repl) >= 1:
            print(f"[跳过] {label}: 已打过补丁")
            continue
        raise ValueError(f"{label}: 找不到原始字节")
    if n != 1:
        raise ValueError(f"{label}: 期望 1 处, 实际 {n} 处")

    idx = data.find(orig)
    data[idx:idx+len(orig)] = repl
    changed += 1
    print(f"[完成] {label} @ offset {idx}")

if changed:
    open("PATH_TO_BINARY", "wb").write(data)
    print(f"[写入] {changed} 处补丁已应用")
else:
    print("[写入] 无需修改")
```

### 3.2 补丁效果示例（2.1.157）

```
替换前: function fW(){if(BK6())return!1;if(!r67())return!1;let{available:H,defaultOn:_}=CP8();if(!H)return!1;return YP5()??_}
替换后: function fW(){return!0/*ULTRACODE_PATCH-----------------------------------------*/}

替换前: function Fx(H){return fW()&&(H===void 0||rcH(H))}
替换后: function Fx(H){return!0/*ULTRACODE_PATCH------*/}
```

---

## 阶段四：后处理

### 4.1 macOS 重签名

字节修改会使 hardened-runtime 签名失效，macOS 会直接 kill 进程：

```bash
codesign --remove-signature "$BIN" 2>/dev/null || true
codesign -f -s - "$BIN"
```

Linux/ELF 跳过此步。

### 4.2 关闭自动更新

否则 Claude Code 更新会用官方原版覆盖补丁：

```bash
node -e "
const fs=require('fs'), p=process.env.HOME+'/.claude/settings.json';
let s={}; try{s=JSON.parse(fs.readFileSync(p,'utf8'))}catch(e){}
s.env=s.env||{}; s.env.DISABLE_AUTOUPDATER='1';
fs.mkdirSync(require('path').dirname(p),{recursive:true});
fs.writeFileSync(p, JSON.stringify(s,null,2)+'\n');
console.log('已写入 DISABLE_AUTOUPDATER=1 ->', p);
"
```

### 4.3 验证

```bash
# 补丁签名存在
grep -a -c -F "function ${WF_NAME}(){return!0/*ULTRACODE_PATCH" "$BIN"   # → 1
grep -a -c -F "function ${GATE_NAME}(H){return!0/*ULTRACODE_PATCH" "$BIN" # → 1

# 原始签名消失
grep -a -c -F "function ${WF_NAME}(){if(${DISABLE_FN}" "$BIN"  # → 0

# 二进制仍可启动
"$BIN" --version
```

### 4.4 告知用户

彻底退出 Claude Code 后重新启动（已运行的进程持有旧二进制在内存中，不受影响）。然后运行 `/effort ultracode`。成功提示：

```
Set effort level to ultracode (this session only): xhigh + dynamic workflow orchestration
```

而非：`Ultracode needs dynamic workflows enabled (see /config) and an xhigh-capable model.`

---

## 回滚

```bash
cp "$HOME/.claude/backups/claude.exe.$VERSION.orig" "$BIN"
[ "$(uname)" = "Darwin" ] && codesign -f -s - "$BIN"
```

---

## 已知版本映射

| 角色 | 2.1.156 | 2.1.157 | 2.1.177 | 结构模板 |
|------|---------|---------|---------|----------|
| workflow 开关 | `v0()` | `fW()` | `TP()` | `function X(){if(Y())return!1;if(!Z())return!1;let{available:H,defaultOn:_}=W();if(!H)return!1;return V()??_}` |
| 显式禁用 | `$K6()` | `BK6()` | `r16()` | 检查 env/settings 禁用 |
| GrowthBook allow | `q67()` | `r67()` | `hg9()` | `return N7("allow_workflows")` |
| 缓存层 | `$P8()` | `CP8()` | `fP8()` | 缓存可用性结果 |
| 默认值回退 | `UX5()` | `YP5()` | `SL5()` | 计划类型回退 |
| ultracode 准入 | `vx(H)` | `Fx(H)` | `Qm(H)` | `function X(H){return Y()&&(H===void 0\|\|Z(H))}` |
| 模型检查 | `VcH(H)` | `rcH(H)` | `KMH(H)` | xhigh 模型兼容 |

结构跨版本一致，只有混淆函数名变化。

---

## 门控架构参考

```
/effort ultracode
  └─ szO() — 命令处理器
      └─ Fx(H) — ultracode 准入门
          ├─ fW() — workflow 开关
          │   ├─ BK6() — 环境变量/settings 显式禁用检查
          │   ├─ r67() — GrowthBook allow_workflows
          │   ├─ CP8() → AP5() — tengu_workflows_enabled + 计划判断
          │   │   └─ Pro 计划: 默认关
          │   │   └─ Max/Team/API: 默认开
          │   └─ YP5() — 默认值回退
          └─ rcH(H) — 模型能力检查（是否 xhigh 可用）
```

---

## 常见坑

1. **不要硬编码字节特征跨版本使用。** 混淆名每次发版都变，必须先跑结构化正则。
2. **替换必须等长。** 长度不一致会导致字节偏移错位，二进制损坏。
3. **macOS 必须重签名。** 没有 `codesign -f -s -`，系统直接 kill 进程。
4. **必须先备份。** `cp "$BIN" ~/.claude/backups/claude.exe.$VERSION.orig`
5. **已打开的会话不受影响。** 运行中的进程持有旧二进制在内存里，只有新启动的进程才用补丁后的。
6. **自动更新会覆盖补丁。** 必须在 settings 中设置 `DISABLE_AUTOUPDATER=1`。
7. **结构模板本身可能变化。** 如果 Anthropic 增加了新的检查层或重构了逻辑，正则会匹配失败——此时进入阶段 2.3 的动态分析模式，从锚点字符串反向追踪。
8. **补丁仅本会话生效。** ultracode 设计上不持久化到 settings，每次新会话需要重新 `/effort ultracode`。

---

## 维护指南：新版本适配流程

当 Claude Code 升级后，按以下顺序操作：

1. 运行阶段 2.1 的快速匹配——如果命中，直接 patch，30 秒搞定
2. 如果未命中，运行阶段 2.2 交叉验证——确认锚点字符串还在
3. 如果锚点在但模板变了，进入阶段 2.3 动态分析——从错误消息反向追踪调用链，重建门控结构
4. 将新版本的映射关系补充到「已知版本映射」表中
5. 如果发现了新的门控层（比如 Anthropic 加了第四层检查），更新正则模板和门控架构图
