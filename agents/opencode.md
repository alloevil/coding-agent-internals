# OpenCode

> 开源免费的终端 AI 编程助手

## 基本信息

| 项 | 值 |
|----|---|
| 出品方 | anomalyco |
| GitHub | [anomalyco/opencode](https://github.com/anomalyco/opencode) |
| 语言 | Go |
| 协议 | MIT |
| 模型 | 75+ 提供商（含 Ollama 本地模型） |
| 价格 | 免费（BYO API Key） |

## 设计哲学

"白嫖党的终端利器，开源界的 Claude Code。"

## 核心能力

- **TUI/CLI 双模式**：TUI 实时可视化执行过程
- **兼容 Claude Code 插件和 Skills 体系**
- **自动上下文压缩**：长对话不爆 token
- **MCP 协议**支持
- **多 Agent 协作**
- **LSP 适配**

## 工具实现

| 维度 | 实现方式 | 层级 |
|------|---------|------|
| 搜索 | rg shell 调用 | Level 1 |
| 编辑 | 纯文本替换 | Level 1 |
| LSP | 有限 | — |
| 上下文管理 | 自动压缩 | — |

## 优势

- 完全免费开源（MIT）
- 75+ 提供商，含本地模型
- 可配任意 API 端点（国内友好）
- 兼容 Claude Code 生态
- 上下文自动压缩
- 完全可审计（无安全顾虑）

## 劣势

- 工具层相对简单
- 复杂任务完成质量取决于底层模型
- 无 LSP/DAP 深度集成
- 无持久记忆
