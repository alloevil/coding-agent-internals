<p align="center">
  <h1 align="center">🔍 Coding Agent Internals</h1>
  <p align="center"><strong>2026 Deep Comparison / 工具实现深度对比</strong></p>
</p>

**Coding Agent Internals** is a source-code-level comparison catalogue that documents how 12 AI coding agents actually implement their tools — code search, code editing, persistent memory, isolation and sub-agents — for engineers choosing or building a coding-agent harness.

<p align="center">
  <img src="https://img.shields.io/badge/Agents-12-blue?style=flat-square" alt="12 Agents">
  <img src="https://img.shields.io/badge/Dimensions-5-green?style=flat-square" alt="5 Dimensions">
  <img src="https://img.shields.io/badge/Year-2026-purple?style=flat-square" alt="2026">
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=flat-square" alt="MIT License">
  <img src="https://img.shields.io/badge/Last%20Updated-Aug%2028-orange?style=flat-square" alt="Last Updated">
</p>

<p align="center">
  <a href="#english">🇺🇸 English</a> · <a href="#中文">🇨🇳 中文</a>
</p>

---

> **EN**: Not feature-list comparisons — deep-dive into **how** each agent's tools are implemented.
> **ZH**: 不是功能列表搬运，而是**工具实现层面**的横向对比。

---

## What it is

Five implementation dimensions — code search, code editing, persistent memory, sandboxing / credential isolation, sub-agents — each get a page that sorts the 12 agents into mechanism levels, and each agent gets a profile page with vendor, form factor, language, licence, pricing and tool implementation. The thesis: these details set the **ceiling** of what a tool can do, so they are worth more than a feature checkbox. Every entry is a dated reading of that agent's source and docs (currently as of 2026-08-28) — agents ship weekly, so treat any single cell as "true when read", not as a permanent property.

这个项目把对比的单位从"宣传的功能"换成"实现方式"：搜索是 fork `rg` 还是进程内引擎、编辑是纯文本替换还是 hash 锚定、有没有持久记忆和凭证隔离。五个维度页 + 12 份 agent 档案，均为带日期的源码级阅读结论（当前截至 2026-08-28）。

## Install

Nothing to install — the catalogue is static pages:

```
https://alloevil.github.io/coding-agent-internals/
```

To read or extend the source Markdown:

```bash
git clone https://github.com/alloevil/coding-agent-internals.git
cd coding-agent-internals
```

The benchmark helpers are plain shell scripts with no build step:

```bash
cd benchmarks
./edit-bench.sh
```

## 🇺🇸 English

### Why This Exists?

Most AI coding agent comparisons are feature checklists. This project focuses on **implementation**:

- **Search**: shell-fork to `rg`, in-process ripgrep, or IDE-native?
- **Edit**: plain-text `str_replace` (whitespace wars), diff+line, or hash-anchored (precise)?
- **Debug**: `print()` statements, or a real DAP debugger wired in?

These details define the **ceiling** of what a tool can do.

---

### 📊 Agents Covered

<table>
<tr>
<td align="center"><a href="agents/claude-code.md"><b>Claude Code</b><br><img src="https://img.shields.io/github/stars/anthropics/claude-code?style=social" alt="stars"></a></td>
<td align="center"><a href="agents/codex.md"><b>Codex</b><br><img src="https://img.shields.io/github/stars/openai/codex?style=social" alt="stars"></a></td>
<td align="center"><a href="agents/omp.md"><b>omp</b><br><img src="https://img.shields.io/github/stars/can1357/oh-my-pi?style=social" alt="stars"></a></td>
<td align="center"><a href="agents/hermes.md"><b>Hermes</b><br><img src="https://img.shields.io/github/stars/NousResearch/hermes-agent?style=social" alt="stars"></a></td>
</tr>
<tr>
<td align="center"><a href="agents/aider.md"><b>Aider</b><br><img src="https://img.shields.io/github/stars/Aider-AI/aider?style=social" alt="stars"></a></td>
<td align="center"><a href="agents/opencode.md"><b>OpenCode</b><br><img src="https://img.shields.io/github/stars/anomalyco/opencode?style=social" alt="stars"></a></td>
<td align="center"><a href="agents/gemini-cli.md"><b>Gemini CLI</b><br><img src="https://img.shields.io/github/stars/google-gemini/gemini-cli?style=social" alt="stars"></a></td>
<td align="center"><a href="agents/copilot-cli.md"><b>Copilot CLI</b><br><img src="https://img.shields.io/github/stars/github/copilot-cli?style=social" alt="stars"></a></td>
</tr>
<tr>
<td align="center"><a href="agents/cursor.md"><b>Cursor</b><br><img src="https://img.shields.io/badge/AI%20IDE-blue?style=flat" alt="IDE"></a></td>
<td align="center"><a href="agents/windsurf.md"><b>Windsurf</b><br><img src="https://img.shields.io/badge/AI%20IDE-blue?style=flat" alt="IDE"></a></td>
<td align="center"><a href="agents/cline.md"><b>Cline</b><br><img src="https://img.shields.io/github/stars/cline/cline?style=social" alt="stars"></a></td>
<td align="center"><a href="agents/devin.md"><b>Devin</b><br><img src="https://img.shields.io/badge/Standalone-gray?style=flat" alt="standalone"></a></td>
</tr>
</table>

---

### 🔬 Terminal CLI Comparison

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

---

### 💡 Key Findings

<details>
<summary><b>🔍 Search: 3 Levels</b></summary>

```
Level 1: shell fork rg/grep     ← Claude Code, Hermes, Aider, OpenCode
Level 2: IDE-native search      ← Cursor, Windsurf, Copilot
Level 3: in-process engine      ← omp (Rust ripgrep — zero fork/exec)
```
</details>

<details>
<summary><b>✏️ Edit: 3 Levels</b></summary>

```
Level 1: plain str_replace      ← most tools
Level 2: diff + line numbers    ← Aider
Level 3: hash-anchored + AST    ← omp (no whitespace wars, no stale file corruption)
```
</details>

<details>
<summary><b>🧠 Memory: 3 Levels</b></summary>

```
None: fresh each session        ← Claude Code, Codex, Aider, OpenCode
Session-level: project-scoped   ← omp (Hindsight — retain/recall, project isolation)
Semantic: cross-session search  ← Hermes (mem0 — semantic retrieval)
```
</details>

<details>
<summary><b>🔒 Security: 3 Levels</b></summary>

```
No isolation: creds everywhere  ← most local tools
Cloud sandbox: isolated env     ← Codex, Devin
Credential Guard: audit log     ← Hermes (unified chokepoint + logging)
```
</details>

---

### 📁 Deep Dives

| Dimension | File | Core Question |
|-----------|------|---------------|
| 🔍 Search | [dimensions/search.md](dimensions/search.md) | grep vs rg vs in-process? |
| ✏️ Edit | [dimensions/editing.md](dimensions/editing.md) | plain text vs hash vs AST? |
| 🧠 Memory | [dimensions/memory.md](dimensions/memory.md) | mem0 vs none vs compression? |
| 🔒 Security | [dimensions/security.md](dimensions/security.md) | guard vs sandbox vs none? |
| 🤖 Sub-agents | [dimensions/subagents.md](dimensions/subagents.md) | worktree vs MOA vs cloud? |

---

## 🇨🇳 中文

### 为什么做这个？

市面上的 AI coding agent 对比文章大多是功能清单罗列。但真正影响日常体验的，是工具的**实现方式**：

- 搜索代码时，是 fork 一个 `rg` 子进程，还是进程内直接调用？
- 编辑文件时，是纯文本替换（容易 whitespace 战争），还是 hash 锚定（精确定位）？
- 调试代码时，是靠 `print()` 大法，还是接入了真正的 DAP 调试器？

这些细节决定了工具的**上限**，而不是"能不能用"。

---

### 📊 终端 CLI Agent 对比

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

---

### 💡 核心发现

<details>
<summary><b>🔍 搜索实现的三个层次</b></summary>

```
Level 1: shell 调用 rg/grep    ← Claude Code, Hermes, Aider, OpenCode
Level 2: IDE 原生搜索           ← Cursor, Windsurf, Copilot
Level 3: 进程内嵌引擎           ← omp (Rust ripgrep — 零 fork/exec)
```
</details>

<details>
<summary><b>✏️ 编辑方式的三个层次</b></summary>

```
Level 1: 纯文本 str_replace    ← 大多数工具
Level 2: diff + 行号定位       ← Aider
Level 3: hash 锚定 + AST      ← omp（消除 whitespace 战争和 stale file 问题）
```
</details>

<details>
<summary><b>🧠 记忆系统的三个层次</b></summary>

```
无记忆：每次会话从零开始       ← Claude Code, Codex, Aider, OpenCode
会话级记忆：项目内持久化       ← omp (Hindsight Memory — retain/recall，项目级隔离)
语义记忆：跨会话语义检索       ← Hermes (mem0 — 按语义而非关键词检索)
```
</details>

<details>
<summary><b>🔒 安全模型的三个层次</b></summary>

```
无隔离：凭证随处可用           ← 大多数本地工具
云端沙箱：隔离执行环境         ← Codex, Devin
凭证卫士：统一管控 + 审计日志  ← Hermes (Credential Guard)
```
</details>

---

### 📁 深度对比

| 维度 | 文件 | 核心问题 |
|------|------|---------|
| 🔍 代码搜索 | [dimensions/search.md](dimensions/search.md) | grep vs rg vs 内嵌引擎？ |
| ✏️ 代码编辑 | [dimensions/editing.md](dimensions/editing.md) | 纯文本 vs hash vs AST？ |
| 🧠 持久记忆 | [dimensions/memory.md](dimensions/memory.md) | mem0 vs 无 vs 上下文压缩？ |
| 🔒 安全隔离 | [dimensions/security.md](dimensions/security.md) | 凭证隔离 vs 沙箱 vs 无？ |
| 🤖 子代理 | [dimensions/subagents.md](dimensions/subagents.md) | worktree vs MOA vs 云端沙箱？ |

---

## When to use it

- You are choosing a coding agent and want to know **why** one fails at edits another applies cleanly, rather than which one has more checkboxes.
- You are building an agent harness and want a survey of the mechanisms in use, and the trade-offs each choice locks in.
- You need per-agent facts (vendor, licence, language, form factor, pricing tier) collected in one place with links onward.

## When NOT to use it

- **You want performance numbers.** There are none. `benchmarks/` ships runnable scripts and a methodology, but its result tables are labelled *expected* (预期结果) — hypotheses, not measurements. Nothing has been run and published, and for that reason this repo publishes no `claims.json`.
- **You want a ranking or a "best agent" verdict.** The catalogue sorts implementations into levels and names the trade-offs; it does not score agents overall.
- **You need guaranteed-current information.** Every entry is a dated reading (as of 2026-08-28). Agents ship weekly — verify any cell your decision actually hinges on against the vendor's current docs.
- **You need pricing you can budget against.** Price rows are indicative tiers as observed, not quotes.
- **You want coverage of non-coding agents** or general IDE autocomplete products. Scope is coding agents with a tool layer.

## FAQ

**Which agents are covered?**
Twelve: Claude Code (Anthropic), Codex (OpenAI), omp / Oh My Pi (can1357), Hermes Agent (Nous Research), Aider (community), OpenCode (anomalyco), Gemini CLI (Google), GitHub Copilot CLI (GitHub/Microsoft), Cursor (Anysphere), Windsurf (Codeium), Cline (community), Devin (Cognition). The first eight are terminal CLIs and appear in the main matrix; the other four are IDEs, an editor extension and a hosted platform, so they appear in the profiles and dimension pages instead.

**Does this project benchmark the agents?**
No. It publishes no measured numbers of its own. `benchmarks/` contains runnable search and edit test cases plus controls (same hardware, same repo commit, three runs taking the median, public scripts) and tables of *expected* results for them. The only percentages in the catalogue are vendor-published SWE-bench figures for two agents, labelled as such.

**Why does hash-anchored editing beat plain-text replacement?**
Plain-text replacement locates the edit by a string the model reproduces from memory, so it fails on indentation mismatch, silently overwrites when the file changed after the model read it, and can hit the wrong occurrence when the string is not unique. A hash anchor is issued by the tool, so a stale or ambiguous anchor is rejected instead of mis-applied; AST awareness lets the tool address a whole construct instead of a text span. The cost is complexity in the tool layer and a format the model must be prompted or trained into.

**How do I cite a finding?**
Cite the specific page, not the site root — the dimension and agent pages are the units that carry the claim, e.g. `https://alloevil.github.io/coding-agent-internals/dimensions/editing.html` or `https://alloevil.github.io/coding-agent-internals/agents/omp.html`. The repository is MIT licensed.

**How do I correct something?**
Open a PR with source-code evidence for the changed cell (see `CONTRIBUTING.md`). Stale entries are corrected rather than accumulated, and the "Last Updated" badge plus the as-of date move with them.

---

## 🤝 Contributing / 贡献

Contributions welcome! / 欢迎贡献！

- **Implementation details** with source-code evidence / 有源码级证据的实现细节
- **Reproducible benchmarks** / 可复现的 benchmark 数据
- **New agents** / 新发布的 agent 信息

---

## 📄 License

MIT

---

<p align="center">
  <b>Keywords</b>: AI coding agent, Claude Code, Codex, omp, oh-my-pi, Hermes Agent, Aider, OpenCode, Gemini CLI, Copilot CLI, Cursor, Windsurf, Cline, Devin, tool implementation, ripgrep, LSP, DAP, hash-anchored edits, 2026
</p>
