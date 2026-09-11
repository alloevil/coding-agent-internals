# omp (Oh My Pi)

> 终端 AI Coding Agent — 把 IDE 能力塞进终端

## 基本信息

| 项 | 值 |
|----|---|
| 出品方 | can1357 (fork 自 Mario Zechner 的 Pi) |
| GitHub | [can1357/oh-my-pi](https://github.com/can1357/oh-my-pi) |
| Stars | 30.7K（30,667，2026-09-12 GitHub API） |
| 语言 | Rust（约 80k 行，六个 crate）+ TypeScript (Bun runtime) |
| 协议 | MIT |
| 首次发布 | 2026 年初 |
| 官网 | [omp.sh](https://omp.sh) |

> 工具数量、行数、提供商数量均取自上游 README（2026-09-12 读取）：**60+** providers · **31** built-in tools · **14** lsp ops · **28** dap ops · **~80k** lines of Rust core — <https://github.com/can1357/oh-my-pi#readme>

## 架构（四层）

```
┌─────────────────────────────────────────────────────┐
│  入口层                                              │
│  TUI / Node SDK / RPC (stdio) / ACP (JSON-RPC)      │
├─────────────────────────────────────────────────────┤
│  Agent Core                                         │
│  会话管理 / 工具调用 / 状态                            │
├─────────────────────────────────────────────────────┤
│  Tool Surface（31 个内置工具）                         │
│  Files & Search | Runtime | Code Intel | Coordination│
├─────────────────────────────────────────────────────┤
│  Rust Native Engine（零 fork）                        │
│  shell / grep / AST / summarize / fs_cache / pty     │
└─────────────────────────────────────────────────────┘
         ↕                          ↕
    60+ Providers            Hindsight Memory
```

## 核心差异化

### 1. Rust 原生引擎（零 fork/exec）

把工具直接编译进进程，不 shell out：

| Crate | 功能 | 行数（上游表） |
|------|------|-----------|
| pi-shell | Embedded bash engine · persistent sessions · in-process coreutils dispatch · minimizer | 38,000 |
| pi-natives | The N-API surface — every native module | 25,000 |
| pi-walker | Parallel ignore-aware walker + scan cache shared by grep · glob · workspace · shell | 5,200 |
| pi-iso | Workspace isolation · apfs · btrfs · zfs · reflink · overlayfs · projfs · rcopy | 3,300 |
| pi-ast | tree-sitter + ast-grep matching, block resolution, structural summaries | 2,900 |
| pi-voice | Audio capture/playback · Opus · live WebRTC | 1,000 |

`pi-natives` 内部的模块级行数（上游表）：grep 3,280 · text 2,070 · keys 1,740 · ast 1,510 · pty 630 · highlight 550。表格逐行照抄上游 README 的 crate / module 表（2026-09-12 读取）。

同一二进制运行在 macOS / Linux / Windows（无需 WSL）。

### 2. Hash 锚定编辑（Hashline）

- 用内容 hash 而非行号定位代码
- 文件变化时 hash 失效，拒绝 patch（防止 stale file 覆盖）
- 消除 whitespace 战争
- 上游 README 数据：Grok 4 Fast 输出 token −61%（厂商自报，非本仓库实测）

### 3. LSP 集成（14 种操作）

rename / diagnostics / navigation / symbols / code actions / raw requests。
通过 `workspace/willRenameFiles` 联动更新 re-exports、barrel files、aliased imports。

### 4. DAP 调试器（28 种操作）

支持 lldb / dlv / debugpy。断点、单步、线程、栈检查、变量求值。
- C segfault → attach lldb，step 到 bad pointer
- Go hang → attach dlv，walk goroutines
- Python wedged → debugpy，pause，inspect

### 5. Time-Traveling Stream Rules

- 规则在模型偏离时才触发
- 正则匹配 → 中断流 → 注入系统提醒 → 从同一点重试
- 注入存活于 compaction，整个会话有效

### 6. Hindsight Memory

- `retain` 写入事实，`recall` 检索
- 会话压缩为 mental model，下次会话首 turn 加载
- 项目级隔离（不同 repo 的记忆不串）

### 7. 代码审查（/review）

- 专用 reviewer 子代理并行扫描
- 问题按 P0-P3 排序 + 置信度评分
- 支持 branch / commit / uncommitted work

### 8. 配置继承

直接读取其他工具的配置，无需迁移：
- Cursor MDC
- Cline .clinerules
- Codex AGENTS.md
- Copilot applyTo

## 内置工具

上游 README 记 **31** built-in tools（`xd://` 设备不计入该数）；下表按功能分类列出核心工具与 xd 设备。

| 类别 | 工具 | 说明 |
|------|------|------|
| **文件和搜索** | read, write, edit, ast_edit, ast_grep, search, find | 文件、目录、archive、SQLite、PDF、URL |
| **运行时** | bash, eval, recipe, ssh | Shell、Python/JS cells、task runners、远程命令 |
| **代码智能** | lsp, debug | 诊断、导航、rename、DAP 调试 |
| **协调** | task, irc, todo_write, job, ask | 子代理、代理间消息、会话状态 |
| **Web** | browser, web_search, github, generate_image, inspect_image, render_mermaid | 浏览器、GitHub、视觉、图表 |
| **记忆和状态** | checkpoint, rewind, retain, recall, reflect | 会话状态、上下文裁剪、持久记忆 |
| **其他** | calc, resolve, search_tool_bm25 | 算术、预览操作、工具发现 |

## 60+ 模型提供商

上游 README：**60+** providers · a thousand models（2026-09-12 读取）。

### Frontier APIs
Anthropic, OpenAI, Google Gemini, xAI, Mistral, Groq, Cerebras, Fireworks, Together, Hugging Face, NVIDIA, OpenRouter, Perplexity 等。

### Coding Plans
Cursor, GitHub Copilot, GitLab Duo, Kimi Code, MiniMax, Alibaba, Qwen, Xiaomi 等（通过 `/login` 订阅路由）。

### Self-Hosted
Ollama, LM Studio, llama.cpp, vLLM, LiteLLM（OpenAI 兼容端点）。

### 路由控制

| 机制 | 说明 |
|------|------|
| 自定义 provider | 声明任何 OpenAI/Anthropic/Google 协议 |
| Fallback 链 | 主 provider 429 时自动切到下一个 |
| 路径级角色 | 单个 repo pin 重模型，不影响全局 |
| 轮询凭证 | 每 provider 多个 API key，session affinity 轮转 |

### 模型角色

| 角色 | 用途 | 切换 |
|------|------|------|
| default | 常规对话 | — |
| smol | 便宜子代理 | `--smol` |
| slow | 深度推理 | `--slow` |
| plan | 规划模式 | `--plan` |
| commit | changelog | — |

## 入口方式

| 入口 | 说明 |
|------|------|
| 交互式 TUI | 默认终端界面，工具卡片、编辑预览、结构化选项 |
| Node SDK | `@oh-my-pi/pi-coding-agent`，嵌入 JS/TS 应用 |
| RPC Mode | stdio NDJSON，非 Node 嵌入器 |
| ACP Mode | JSON-RPC，编辑器集成（Zed 等） |

## 安装

```bash
# macOS / Linux
curl -fsSL https://omp.sh/install | sh

# Bun（推荐）
bun install -g @oh-my-pi/pi-coding-agent

# Windows (PowerShell)
irm https://omp.sh/install
```
