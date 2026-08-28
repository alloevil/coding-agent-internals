# Aider

> 老牌开源终端 AI 编程助手

## 基本信息

| 项 | 值 |
|----|---|
| 出品方 | 开源社区（Paul Gauthier） |
| GitHub | [Aider-AI/aider](https://github.com/Aider-AI/aider) |
| 语言 | Python |
| 协议 | Apache 2.0 |
| 模型 | 多模型支持（OpenAI / Claude / Gemini / 本地） |
| 价格 | 免费（BYO API Key） |

## 设计哲学

Pair programming 模式——你和 AI 一起写代码。

## 核心能力

- **Git 感知**：自动 commit，理解 git 历史
- **多模型支持**：接入各种 LLM
- **Pair programming**：交互式编码，不是"扔任务走人"
- **编辑地图**：理解仓库结构

## 工具实现

| 维度 | 实现方式 | 层级 |
|------|---------|------|
| 搜索 | rg shell 调用 | Level 1 |
| 编辑 | diff + 行号定位 | Level 2 |
| Git | 深度集成，自动 commit | — |

## 优势

- 老牌稳定，社区成熟
- Git 集成深度
- 多模型灵活切换
- 免费开源

## 劣势

- 无子代理能力
- 无 LSP/DAP
- 无持久记忆
- 交互式模式，不适合自主后台任务
