# Hermes Agent

> 自我进化的开源 AI 开发者

## 基本信息

| 项 | 值 |
|----|---|
| 出品方 | Nous Research |
| GitHub | [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent) |
| Stars | 244.5K（244,530，2026-09-12 GitHub API） |
| 语言 | Python（GitHub 语言；`pyproject.toml` requires-python >=3.11） |
| 协议 | MIT |
| 首个 Release | [v2026.3.12](https://github.com/NousResearch/hermes-agent/releases)（2026-03-12，GitHub Releases 中最早的 tag；PyPI 最早发布 0.13.0 于 2026-05-14） |
| 当前版本 | [v0.20.6](https://github.com/NousResearch/hermes-agent/releases/tag/v2026.8.27)（2026-08-27） |
| 官网 | [hermes-agent.nousresearch.com](https://hermes-agent.nousresearch.com) |

## 核心差异化

### 1. delegate_task 子代理

核心原语。每个子代理获得：
- **独立工作目录**：隔离 scratch space，任务间不互相干扰
- **独立 LLM 分配**：便宜模型做模板提取，贵模型做困难推理
- **失败恢复逻辑**：重试、fallback、有界升级（不是一次致命错误）
- **父子关系可见**：编排器可 inspect / kill / merge 子代理工作

适合组合式工程任务：重构模块 → 更新测试 → 重新生成文档 → 开 PR。

### 2. Mixture-of-Agents (MOA)

多个专家模型从不同角度分析 → 聚合器综合答案。
- 单模型有盲区，多模型投票互相抵消弱点
- 官方 HermesBench 数据（厂商自报）：两模型 MoA 预设（`claude-opus-4.8` 作聚合器 + `gpt-5.5` 作参考）得分 0.8202，高于单跑 opus-4.8 的 0.7607 与 gpt-5.5 的 0.7412
- 文档明确：MoA 不破坏主会话的 prompt cache，代价是每次迭代多出参考模型调用

来源：<https://hermes-agent.nousresearch.com/docs/user-guide/features/mixture-of-agents>

### 3. 多模型路由（任意 OpenAI 兼容提供商）

上游 README：「Use any model you want — Nous Portal, OpenRouter, OpenAI, your own endpoint, and many others」；上游未给出提供商数量，Nous Portal 订阅提供 **300+ models**。

根据信号自动选择最优模型：

| 信号 | 说明 |
|------|------|
| 任务复杂度 | 简单分类 → 小模型；架构工作 → frontier 模型 |
| 上下文需求 | 长仓库任务 → 大上下文窗口 |
| 速度需求 | 交互循环 → 低延迟；批处理 → 可接受慢 |
| 成本敏感度 | 后台爬虫不应烧 premium token |
| 能力需求 | 某些模型更擅长 tool use / code / reasoning |

### 4. 命令审批与凭证处理（8 层安全模型）

Hermes 文档描述的是 **8 层安全模型**，其中没有名为 "Credential Guard" 的统一凭证关卡，也没有凭证访问审计日志：

1. 用户授权（allowlist、DM pairing）
2. 危险命令审批（`approvals.mode`: smart / manual / off，默认 smart；超时默认拒绝）
3. 文件写入安全（denylist + 可选写入沙箱）
4. 容器隔离（Docker / Singularity / Modal / Daytona 等；容器内跳过审批检查）
5. MCP 凭证过滤（MCP 子进程的环境变量隔离）
6. 上下文文件扫描（提示注入检测）
7. 跨会话隔离
8. 输入净化（终端后端的工作目录参数按 allowlist 校验）

来源：<https://hermes-agent.nousresearch.com/docs/user-guide/security>

### 5. 记忆：内置文件 + 8 个可选外部提供方

- 内置记忆始终启用：`MEMORY.md`（2,200 字符，约 800 tokens）+ `USER.md`（1,375 字符，约 500 tokens），会话开始时作为冻结快照注入 system prompt
- `session_search` 用 SQLite FTS5 全文检索历史会话（文档称无 LLM 调用；查询约 20ms）
- 另有 **8 个外部记忆提供方插件**（honcho、openviking、mem0、hindsight、holographic、retaindb、byterover、supermemory），同一时间只能启用其中一个

来源：<https://hermes-agent.nousresearch.com/docs/user-guide/features/memory> 与 <https://hermes-agent.nousresearch.com/docs/user-guide/features/memory-providers>

### 6. 内置 Cron

定时调度自主 agent：
- 每个 job 独立会话 + 独立工作目录 + 独立技能集
- 结果路由到 Slack / Discord / Telegram / Email
- 一个 job 失败不会污染下一个 job 的状态
- 用途：每小时 digest、每晚重构、每周依赖审计

### 7. Skill 系统

可复用包：SKILL.md 指令 + 脚本 + 模板。
- 从本地路径 / git repo / 社区注册表安装
- 核心小，边缘无限扩展
- 配合 AGENTS.md 文档化团队约定

### 8. 自我进化

- 自动将用户操作转化为可复用 Skill
- 零代码进化
- 技能本地存储、跨平台互通

### 9. Console 仪表盘

- WebSocket 实时连接浏览器
- 可视化：agent 状态、委派关系、工具调用、当前思考
- 支持实时中断和引导
- 对长时间运行的 job 不是奢侈品，是必需品

## Token 开销（官方文档记载）

| 项 | Hermes 文档记载 |
|------|---------|
| 内置记忆上限 | MEMORY.md 2,200 字符（约 800 tokens）+ USER.md 1,375 字符（约 500 tokens） |
| 会话检索 | SQLite FTS5，文档称无 LLM 调用；查询约 20ms |
| 上下文压缩 | 双压缩系统，默认阈值 `threshold: 0.50`（prompt 达到上下文窗口 50% 时触发）；文档示例：45 条消息约 95K tokens → 25 条约 45K tokens |
| Prompt 缓存 | 系统提示跨轮保持不变；插件文档称多轮会话中缓存可省 75%+ 输入 token |

来源：<https://hermes-agent.nousresearch.com/docs/user-guide/features/memory>、<https://hermes-agent.nousresearch.com/docs/developer-guide/context-compression-and-caching>、<https://hermes-agent.nousresearch.com/docs/developer-guide/plugins>

## 什么时候选 Hermes

✅ 需要自主 + 控制：后台任务、多步重构、定时杂务、多模型路由
✅ 在意命令审批与容器隔离
✅ 需要跨会话记忆

❌ 轻量任务（解释函数、生成片段）→ 用更轻的工具
❌ 需要实时 Tab 补全 → 用 Cursor
