# Hermes Agent

> 自我进化的开源 AI 开发者

## 基本信息

| 项 | 值 |
|----|---|
| 出品方 | Nous Research |
| GitHub | [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent) |
| Stars | 50K+（发布数周内） |
| 语言 | TypeScript |
| 协议 | MIT |
| 首次发布 | 2026-02-25 |
| 当前版本 | v0.20.6 (2026-08-27) |
| 官网 | [hermes-agent.ai](https://hermes-agent.ai) |

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
- 配合 prompt caching，速度提升 4x
- 从"MOA 太贵了"变成"MOA 是默认行为"

### 3. 多模型智能路由（15+ 提供商）

根据信号自动选择最优模型：

| 信号 | 说明 |
|------|------|
| 任务复杂度 | 简单分类 → 小模型；架构工作 → frontier 模型 |
| 上下文需求 | 长仓库任务 → 大上下文窗口 |
| 速度需求 | 交互循环 → 低延迟；批处理 → 可接受慢 |
| 成本敏感度 | 后台爬虫不应烧 premium token |
| 能力需求 | 某些模型更擅长 tool use / code / reasoning |

### 4. Credential Guard

所有凭证访问走统一关卡：
1. 验证调用者
2. 检查授权
3. 记录审计日志

- 子代理只拿最小权限（principle of least privilege）
- 本地工具看不到云端凭证，反之亦然
- 审计日志：谁、什么时候、访问了什么

### 5. mem0 语义记忆

- 跨会话持久记忆
- 按语义（非关键词）检索
- 存储：用户偏好、项目约定、历史决策
- 示例："这个 repo 用 tab 缩进"、"staging 部署需要手动审批"
- 注意：记忆是项目上下文，不是凭证保险库

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

## Token 效率优势

| 维度 | Hermes | 其他工具 |
|------|--------|---------|
| 基线开销 | ~12.5K tokens | 更高 |
| 工具 schema 压缩 | opt-in 轻量 profile，省 68-84% | 无 |
| 技能加载 | 渐进式：Level 0 只看名称 | 全量加载 |
| 上下文压缩 | 自动压缩，hot/cold 分离 | 靠大窗口硬撑 |

## 什么时候选 Hermes

✅ 需要自主 + 控制：后台任务、多步重构、定时杂务、多模型路由
✅ 在意凭证隔离
✅ 需要跨会话记忆

❌ 轻量任务（解释函数、生成片段）→ 用更轻的工具
❌ 需要实时 Tab 补全 → 用 Cursor
