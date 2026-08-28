# GitHub Copilot CLI

> GitHub 出品，终端编码代理

## 基本信息

| 项 | 值 |
|----|---|
| 出品方 | GitHub / Microsoft |
| GitHub | [github/copilot-cli](https://github.com/github/copilot-cli/) |
| 形态 | 终端 CLI + IDE 插件 + Desktop App |
| 模型 | 多模型（GPT / Claude / Gemini） |
| 开源 | ❌ |
| GA 日期 | 2026-02-25 |
| 价格 | $10/月 Copilot Pro（每次 prompt 消耗 1 premium request） |

## 核心能力

### 自动驾驶模式（Autopilot）
用 `/delegate` 斜杠命令或自动驾驶模式，让 Copilot 自动替你工作。

### 自定义 Agent 和 Skills
- 创建自定义 Agent
- 为 Agent 添加 Skills
- 全局 `.agent.md` 支持

### 多入口
- CLI 终端
- IDE 集成（VS Code / JetBrains）
- Desktop App（独立原生应用）
- 云端 Agent

### 2026-08 更新
- 重新设计的终端 UI（选项卡 + 免配置文件工具设置）
- VS Code 深度集成

## 工具实现

| 维度 | 实现方式 | 层级 |
|------|---------|------|
| 搜索 | 内置 | — |
| 编辑 | 纯文本替换 | Level 1 |
| 执行环境 | 本地 + 云端（Background Agent） | — |
| Git | 深度集成（GitHub 原生） | 最强 |
| IDE 集成 | VS Code / JetBrains | — |

## 优势

- GitHub 原生集成（Issue → PR → Review 全链路）
- 多模型支持
- 多入口（CLI / IDE / Desktop / Cloud）
- 自定义 Agent 和 Skills 生态
- 价格低（$10/月）

## 劣势

- 工具层相对简单
- 闭源
- 每次 prompt 消耗 premium request，重度使用成本累积
- 国内访问受限
