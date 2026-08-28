# Coding Agent Internals — 2026 工具实现深度对比

> 不是功能列表搬运，而是**工具实现层面**的横向对比。
> 关注的不是"有没有搜索功能"，而是"搜索用的是 rg shell 调用、内嵌 ripgrep、还是 IDE 原生搜索"。

**12 个 Agent · 5 个维度 · 聚焦 2026**

**最后更新：2026-08-28**

## Why This Exists?

市面上的 AI coding agent 对比文章大多是功能清单罗列。但真正影响日常体验的，是工具的**实现方式**：

- 搜索代码时，是 fork 一个 `rg` 子进程，还是进程内直接调用？
- 编辑文件时，是纯文本替换（容易 whitespace 战争），还是 hash 锚定（精确定位）？
- 调试代码时，是靠 `print()` 大法，还是接入了真正的 DAP 调试器？

这些细节决定了工具的**上限**，而不是"能不能用"。

### Agents Covered

| Agent | Stars | Type |
|-------|-------|------|
| [Claude Code](agents/claude-code.md) | — | Terminal CLI |
| [Codex](agents/codex.md) | — | CLI + Cloud |
| [omp](agents/omp.md) | 17.7K+ | Terminal CLI |
| [Hermes Agent](agents/hermes.md) | 50K+ | Terminal CLI |
| [Aider](agents/aider.md) | — | Terminal CLI |
| [OpenCode](agents/opencode.md) | — | Terminal CLI |
| [Gemini CLI](agents/gemini-cli.md) | 97K+ | Terminal CLI |
| [Copilot CLI](agents/copilot-cli.md) | — | Terminal CLI |
| [Cursor](agents/cursor.md) | — | AI IDE |
| [Windsurf](agents/windsurf.md) | — | AI IDE |
| [Cline](agents/cline.md) | — | VS Code 插件 |
| [Devin](agents/devin.md) | — | 独立平台 |

## 对比总览

### 终端 CLI Agent

| 维度 | Claude Code | Codex | omp | Hermes | Aider | OpenCode | Gemini CLI | Copilot CLI |
|------|------------|-------|-----|--------|-------|----------|-----------|------------|
| 出品方 | Anthropic | OpenAI | can1357 | Nous Research | 开源社区 | anomalyco | Google | GitHub/MS |
| 语言 | TS | TS | Rust+TS | TS | Python | Go | TS | — |
| 开源 | ❌ | CLI ✅ | ✅ MIT | ✅ MIT | ✅ Apache | ✅ MIT | ✅ | ❌ |
| 模型锁定 | 仅 Claude | 仅 GPT | 40+ 提供商 | 15+ 智能路由 | 多模型 | 75+ 提供商 | 仅 Gemini | 多模型 |
| 搜索实现 | rg shell 调用 | 内置 | **内嵌 ripgrep** | rg shell 调用 | rg shell 调用 | rg shell 调用 | 内置 | 内置 |
| 编辑方式 | 纯文本替换 | 纯文本 | **Hash 锚定 + AST** | 纯文本 | 纯文本 + diff | 纯文本 | 纯文本 | 纯文本 |
| LSP 集成 | ❌ | ❌ | ✅ 13 种操作 | ❌ | ❌ | 有限 | ❌ | ❌ |
| DAP 调试 | ❌ | ❌ | ✅ 27 种操作 | ❌ | ❌ | ❌ | ❌ | ❌ |
| 子代理 | ✅ Agent Teams | ✅ 云端并行 | ✅ 隔离 worktree | ✅ MOA 多模型 | ❌ | ✅ 有限 | ❌ | ✅ Background Agent |
| 持久记忆 | ❌ | ❌ | ✅ Hindsight | ✅ mem0 | ❌ | ❌ | ❌ | ❌ |
| 内置 Cron | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| 凭证隔离 | ❌ | 云端沙箱 | ❌ | ✅ Credential Guard | ❌ | ❌ | ❌ | ❌ |
| 浏览器 | ✅ Playwright | ❌ | ✅ stealth browsing | ❌ | ❌ | ❌ | ✅ | ❌ |
| MCP 协议 | ✅ | ❌ | ✅ | ✅ | ❌ | ✅ | ✅ | ❌ |
| 上下文窗口 | 200K | 1M | 取决于模型 | 取决于模型 | 取决于模型 | 取决于模型 | 取决于模型 | 取决于模型 |
| SWE-bench | 88.6% | 82.6% | — | — | — | — | — | — |
| 价格 | $20-200/月 | $20-200/月 | 免费 BYO | 免费 BYO | 免费 BYO | 免费 BYO | 免费额度 | $10/月 |

### AI IDE / 插件

| 维度 | Cursor | Windsurf | Copilot | Cline | Trae | CodeBuddy |
|------|--------|----------|---------|-------|------|-----------|
| 出品方 | Anysphere | Codeium | GitHub/MS | 开源社区 | 字节跳动 | 腾讯 |
| 形态 | VS Code Fork | VS Code Fork | IDE 插件 | VS Code 插件 | 独立 IDE | IDE/插件 |
| Tab 补全 | ✅ **最强** | ✅ Cascade | ✅ | ❌ | ✅ | ✅ |
| Agent 模式 | ✅ | ✅ | ✅ (2026) | ✅ | ✅ | ✅ |
| MCP | ✅ | ✅ | ❌ | ✅ | ✅ | ❌ |
| 开源 | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| 价格 | $20/月 | $15/月 | $10/月 | ✅ BYO Key | 免费额度 | 免费额度 |

### 自主执行组

| 维度 | Devin | Codex | Claude Code | Hermes | omp |
|------|-------|-------|------------|--------|-----|
| 执行环境 | 云端一体 | 云端沙箱 | 本地 | 本地 | 本地 |
| 并行能力 | ✅ 多任务 | ✅ 多任务 | ✅ Agent Teams | ✅ delegate_task | ✅ 子代理 |
| 浏览器 | ✅ 内置 | ❌ | ✅ | ❌ | ✅ |
| 自动 PR | ✅ | ✅ | ✅ | ✅ | ✅ |
| Cron 定时 | ❌ | ❌ | ❌ | ✅ | ❌ |
| 价格 | $500/月 | $20-200/月 | $20-200/月 | 免费 BYO | 免费 BYO |

## 深度维度对比

按工具实现方式横向切片：

| 维度 | 文件 | 核心问题 |
|------|------|---------|
| 代码搜索 | [dimensions/search.md](dimensions/search.md) | grep vs rg vs 内嵌引擎？ |
| 代码编辑 | [dimensions/editing.md](dimensions/editing.md) | 纯文本 vs hash 锚定 vs AST？ |
| 持久记忆 | [dimensions/memory.md](dimensions/memory.md) | mem0 vs 无 vs 上下文压缩？ |
| 安全隔离 | [dimensions/security.md](dimensions/security.md) | 凭证隔离 vs 沙箱 vs 无？ |
| 子代理 | [dimensions/subagents.md](dimensions/subagents.md) | 隔离 worktree vs MOA vs 云端沙箱？ |

## 各 Agent 详情

| Agent | 文件 |
|-------|------|
| Claude Code | [agents/claude-code.md](agents/claude-code.md) |
| Codex | [agents/codex.md](agents/codex.md) |
| omp (Oh My Pi) | [agents/omp.md](agents/omp.md) |
| Hermes Agent | [agents/hermes.md](agents/hermes.md) |
| Aider | [agents/aider.md](agents/aider.md) |
| OpenCode | [agents/opencode.md](agents/opencode.md) |
| Gemini CLI | [agents/gemini-cli.md](agents/gemini-cli.md) |
| Copilot CLI | [agents/copilot-cli.md](agents/copilot-cli.md) |
| Cursor | [agents/cursor.md](agents/cursor.md) |
| Windsurf | [agents/windsurf.md](agents/windsurf.md) |
| Cline | [agents/cline.md](agents/cline.md) |
| Devin | [agents/devin.md](agents/devin.md) |

## 核心发现

### 1. 搜索实现的三个层次

```
Level 1: shell 调用 rg/grep    ← Claude Code, Hermes, Aider, OpenCode
Level 2: IDE 原生搜索           ← Cursor, Windsurf, Copilot
Level 3: 进程内嵌引擎           ← omp (Rust ripgrep), omp (brush shell)
```

Level 3 没有 fork/exec 开销，在大仓库中差距明显。

### 2. 编辑方式的三个层次

```
Level 1: 纯文本 str_replace    ← 大多数工具
Level 2: diff + 行号定位       ← Aider
Level 3: hash 锚定 + AST      ← omp（消除 whitespace 战争和 stale file 问题）
```

### 3. 记忆系统的三个层次

```
无记忆：每次会话从零开始       ← Claude Code, Codex, Aider, OpenCode
会话级记忆：项目内持久化       ← omp (Hindsight Memory — retain/recall，项目级隔离)
语义记忆：跨会话语义检索       ← Hermes (mem0 — 按语义而非关键词检索)
```

### 4. 安全模型的三个层次

```
无隔离：凭证随处可用           ← 大多数本地工具
云端沙箱：隔离执行环境         ← Codex, Devin
凭证卫士：统一管控 + 审计日志  ← Hermes (Credential Guard)
```

## 贡献

欢迎补充、纠正、更新。尤其是：

- 各 agent 的**实际工具实现细节**（源码级证据）
- 可复现的 benchmark 数据
- 新发布的 agent 信息

## License

MIT

---

**Keywords**: AI coding agent, Claude Code, Codex, omp, oh-my-pi, Hermes Agent, Aider, OpenCode, Gemini CLI, Copilot CLI, Cursor, Windsurf, Cline, Devin, tool implementation, ripgrep, LSP, DAP, hash-anchored edits, 2026
