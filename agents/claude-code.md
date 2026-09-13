# Claude Code

> Anthropic 出品，终端里的 AI Agent

## 基本信息

| 项 | 值 |
|----|---|
| 出品方 | Anthropic |
| 形态 | 终端 CLI |
| 模型 | 仅 Claude 系列 |
| 上下文 | 1M（Opus 4.8） |
| 开源 | ❌ |
| SWE-bench | 88.6% SWE-bench Verified（Opus 4.8，2026-05-28）——[System Card](https://www.anthropic.com/claude-opus-4-8-system-card) §8.2 |
| 价格 | $20/月 Pro → $100/月 Max 5x → $200/月 Max 20x |
| 首次发布 | 2025-02-24（limited research preview）→ 2025-05-22 GA；来源：[Claude 3.7 Sonnet](https://www.anthropic.com/news/claude-3-7-sonnet)、[Claude 4](https://www.anthropic.com/news/claude-4) |

## 设计哲学

"你当项目经理，它当程序员。"

给它一个任务描述，它自己读代码、改文件、跑测试、修 bug、提 PR。全程你在旁边看着就行。

## 核心能力

### Dynamic Workflows
单会话里并行跑数百个 subagent。1M 上下文 + 动态工作流让它能处理大规模重构。

### Agent Teams
多个子代理并行工作，每个在独立上下文中。

### 深度 Git 集成
自动读代码、制定重构计划、逐步执行、跑测试验证。本地执行，可实时看到进度并随时打断。

### 浏览器自动化
Playwright 集成，支持 web 测试和文档查阅。

### MCP 协议
支持 Model Context Protocol，可接入外部工具和数据源。

## 工具实现

| 维度 | 实现方式 | 层级 |
|------|---------|------|
| 搜索 | rg shell 调用 | Level 1 |
| 编辑 | 纯文本替换 | Level 1 |
| LSP | ❌ | — |
| DAP | ❌ | — |
| 记忆 | ❌（靠 1M 上下文硬撑） | — |
| 凭证 | 无隔离 | Level 1 |
| 浏览器 | Playwright | — |
| 子代理 | Agent Teams | 隔离上下文 |

## 已知问题

### 追踪事件（2026-07）

| 时间 | 事件 | 依据 |
|------|------|------|
| v2.1.91 起 | 植入追踪代码（起始日期无公开来源，本仓库先前写作"4月2日"） | 版本区间见复盘 |
| 公开披露 | 安全研究者逆向审查后披露（复盘未给出确切日期） | 复盘未载明 |
| Anthropic 回应 | 称为**反蒸馏实验（anti-distillation）**并移除 | 复盘 |
| 7月1–2日 | v2.1.197 移除追踪代码 | 复盘标为 "Jul 1–2, 2026" |
| 7月8日 | 工信部 NVDB 定性为"存在安全后门隐患" | 复盘 |

**做了什么**：检测中国用户时区（Asia/Shanghai、Asia/Urumqi）并把 `ANTHROPIC_BASE_URL` 主机名与内置代理域名黑名单对照；用 Unicode 隐写（日期分隔符与撇号变体）把分类结果嵌进 system prompt。**黑名单条数未见公开数字**（本仓库先前写作"147+"，无来源，已删）。
**关键点**：机制写在 system prompt 内，与遥测端点上报不是同一条通道；`DISABLE_TELEMETRY` 的官方口径只覆盖 usage analytics，是否约束该机制**没有公开结论**；改时区可避免被标记（VPN 无效）。

> 来源：业界复盘 <https://meshlaunch.com/en/blog/2026-claude-code-backdoor-miit-warning.html>、遥测变量说明 <https://ghuneim.us/blog/disabling-claude-code-telemetry/>。NVDB（工信部）2026-07-08 的通告是原始出处，本次未能直接抓取，其日期与定性经上述复盘交叉确认。

## 优势

- SWE-bench Verified 88.6%（Opus 4.8，Anthropic 系统卡）
- 深度理解能力最强（1M 上下文）
- 本地执行可实时调整
- Dynamic Workflows 支持复杂任务

## 劣势

- 仅支持 Claude 模型
- 工具层相对简单（纯文本替换、无 LSP/DAP）
- 无持久记忆
- 追踪事件影响国内信任度
- 国内需翻墙或配代理
