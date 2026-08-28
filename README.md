# Coding Agent Internals — 2026 Deep Comparison / 工具实现深度对比

> **EN**: Not feature-list comparisons — deep-dive into **how** each agent's tools are implemented.
> **ZH**: 不是功能列表搬运，而是**工具实现层面**的横向对比。

**12 Agents · 5 Dimensions · 2026** | **12 个 Agent · 5 个维度 · 聚焦 2026**

**Last updated / 最后更新：2026-08-28**

---

## English

### Why This Exists?

Most AI coding agent comparisons are feature checklists. This project focuses on **implementation**:

- **Search**: shell-fork to `rg`, in-process ripgrep, or IDE-native?
- **Edit**: plain-text `str_replace` (whitespace wars), diff+line, or hash-anchored (precise)?
- **Debug**: `print()` statements, or a real DAP debugger wired in?

These details define the **ceiling** of what a tool can do.

### Agents Covered

| Agent | ⭐ Stars | Type |
|-------|----------|------|
| [Claude Code](agents/claude-code.md) | 143K | Terminal CLI |
| [Codex](agents/codex.md) | 119K | CLI + Cloud |
| [omp](agents/omp.md) | 28K | Terminal CLI |
| [Hermes Agent](agents/hermes.md) | 237K | Terminal CLI |
| [Aider](agents/aider.md) | 48K | Terminal CLI |
| [OpenCode](agents/opencode.md) | 202K | Terminal CLI |
| [Gemini CLI](agents/gemini-cli.md) | 107K | Terminal CLI |
| [Copilot CLI](agents/copilot-cli.md) | 11K | Terminal CLI |
| [Cursor](agents/cursor.md) | — | AI IDE |
| [Windsurf](agents/windsurf.md) | — | AI IDE |
| [Cline](agents/cline.md) | 67K | VS Code Extension |
| [Devin](agents/devin.md) | — | Standalone Platform |

### Terminal CLI Comparison

| Dim | Claude Code | Codex | omp | Hermes | Aider | OpenCode | Gemini CLI | Copilot CLI |
|-----|------------|-------|-----|--------|-------|----------|-----------|------------|
| Vendor | Anthropic | OpenAI | can1357 | Nous Research | Community | anomalyco | Google | GitHub/MS |
| Language | TS | TS | Rust+TS | TS | Python | Go | TS | — |
| Open Source | ❌ | CLI ✅ | ✅ MIT | ✅ MIT | ✅ Apache | ✅ MIT | ✅ | ❌ |
| Model Lock | Claude only | GPT only | 40+ providers | 15+ smart routing | Multi-model | 75+ providers | Gemini only | Multi-model |
| Search | rg shell fork | built-in | **in-process ripgrep** | rg shell fork | rg shell fork | rg shell fork | built-in | built-in |
| Edit | plain text | plain text | **hash-anchored + AST** | plain text | plain text + diff | plain text | plain text | plain text |
| LSP | ❌ | ❌ | ✅ 13 ops | ❌ | ❌ | limited | ❌ | ❌ |
| DAP | ❌ | ❌ | ✅ 27 ops | ❌ | ❌ | ❌ | ❌ | ❌ |
| Sub-agents | ✅ Agent Teams | ✅ cloud parallel | ✅ isolated worktree | ✅ MOA multi-model | ❌ | ✅ limited | ❌ | ✅ Background Agent |
| Memory | ❌ | ❌ | ✅ Hindsight | ✅ mem0 | ❌ | ❌ | ❌ | ❌ |
| Cron | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Credential Guard | ❌ | cloud sandbox | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Browser | ✅ Playwright | ❌ | ✅ stealth | ❌ | ❌ | ❌ | ✅ | ❌ |
| MCP | ✅ | ❌ | ✅ | ✅ | ❌ | ✅ | ✅ | ❌ |
| Context | 200K | 1M | model-dependent | model-dependent | model-dependent | model-dependent | model-dependent | model-dependent |
| SWE-bench | 88.6% | 82.6% | — | — | — | — | — | — |
| Price | $20-200/mo | $20-200/mo | free BYO | free BYO | free BYO | free BYO | free tier | $10/mo |

### Key Findings

**Search: 3 Levels**
```
Level 1: shell fork rg/grep     ← Claude Code, Hermes, Aider, OpenCode
Level 2: IDE-native search      ← Cursor, Windsurf, Copilot
Level 3: in-process engine      ← omp (Rust ripgrep — zero fork/exec)
```

**Edit: 3 Levels**
```
Level 1: plain str_replace      ← most tools
Level 2: diff + line numbers    ← Aider
Level 3: hash-anchored + AST    ← omp (no whitespace wars, no stale file corruption)
```

**Memory: 3 Levels**
```
None: fresh each session        ← Claude Code, Codex, Aider, OpenCode
Session-level: project-scoped   ← omp (Hindsight — retain/recall, project isolation)
Semantic: cross-session search  ← Hermes (mem0 — semantic retrieval)
```

**Security: 3 Levels**
```
No isolation: creds everywhere  ← most local tools
Cloud sandbox: isolated env     ← Codex, Devin
Credential Guard: audit log     ← Hermes (unified chokepoint + logging)
```

### Deep Dives

| Dimension | File | Core Question |
|-----------|------|---------------|
| Search | [dimensions/search.md](dimensions/search.md) | grep vs rg vs in-process? |
| Edit | [dimensions/editing.md](dimensions/editing.md) | plain text vs hash vs AST? |
| Memory | [dimensions/memory.md](dimensions/memory.md) | mem0 vs none vs compression? |
| Security | [dimensions/security.md](dimensions/security.md) | guard vs sandbox vs none? |
| Sub-agents | [dimensions/subagents.md](dimensions/subagents.md) | worktree vs MOA vs cloud? |

---

## 中文

### 为什么做这个？

市面上的 AI coding agent 对比文章大多是功能清单罗列。但真正影响日常体验的，是工具的**实现方式**：

- 搜索代码时，是 fork 一个 `rg` 子进程，还是进程内直接调用？
- 编辑文件时，是纯文本替换（容易 whitespace 战争），还是 hash 锚定（精确定位）？
- 调试代码时，是靠 `print()` 大法，还是接入了真正的 DAP 调试器？

这些细节决定了工具的**上限**，而不是"能不能用"。

### 终端 CLI Agent 对比

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

### 核心发现

**搜索实现的三个层次**
```
Level 1: shell 调用 rg/grep    ← Claude Code, Hermes, Aider, OpenCode
Level 2: IDE 原生搜索           ← Cursor, Windsurf, Copilot
Level 3: 进程内嵌引擎           ← omp (Rust ripgrep — 零 fork/exec)
```

**编辑方式的三个层次**
```
Level 1: 纯文本 str_replace    ← 大多数工具
Level 2: diff + 行号定位       ← Aider
Level 3: hash 锚定 + AST      ← omp（消除 whitespace 战争和 stale file 问题）
```

**记忆系统的三个层次**
```
无记忆：每次会话从零开始       ← Claude Code, Codex, Aider, OpenCode
会话级记忆：项目内持久化       ← omp (Hindsight Memory — retain/recall，项目级隔离)
语义记忆：跨会话语义检索       ← Hermes (mem0 — 按语义而非关键词检索)
```

**安全模型的三个层次**
```
无隔离：凭证随处可用           ← 大多数本地工具
云端沙箱：隔离执行环境         ← Codex, Devin
凭证卫士：统一管控 + 审计日志  ← Hermes (Credential Guard)
```

---

## Contributing / 贡献

Contributions welcome! Especially:
欢迎补充、纠正、更新。尤其是：

- **Implementation details** with source-code evidence / 有源码级证据的实现细节
- **Reproducible benchmarks** / 可复现的 benchmark 数据
- **New agents** / 新发布的 agent 信息

## License

MIT

---

**Keywords**: AI coding agent, Claude Code, Codex, omp, oh-my-pi, Hermes Agent, Aider, OpenCode, Gemini CLI, Copilot CLI, Cursor, Windsurf, Cline, Devin, tool implementation, ripgrep, LSP, DAP, hash-anchored edits, 2026
