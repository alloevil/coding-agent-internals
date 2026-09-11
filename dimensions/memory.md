# 持久记忆 — 实现方式对比

## 两个极端

### 无记忆：每次会话从零开始

| Agent | 状态 |
|-------|------|
| Claude Code | ❌ 无持久记忆（靠 1M 上下文硬撑） |
| Codex | ❌ 无持久记忆 |
| Aider | ❌ 无持久记忆 |
| OpenCode | ❌ 无持久记忆（有上下文压缩） |
| Cursor | ❌ 无持久记忆 |

这些工具依赖：会话内上下文、项目文件（AGENTS.md 等）、用户每次重述偏好。

### 会话级记忆：项目内持久化

| Agent | 实现方式 |
|-------|---------|
| omp | Hindsight Memory — retain/recall，会话压缩为 mental model，项目级隔离 |

**omp Hindsight**：
- `retain` 写入事实，`recall` 检索
- 会话压缩为 mental model，下次会话首 turn 加载
- 项目级隔离（不同 repo 的记忆不串）

### 外部提供方记忆：内置文件 + 可选插件

| Agent | 实现方式 |
|-------|---------|
| Hermes | 内置 `MEMORY.md`（2,200 字符）/ `USER.md`（1,375 字符）+ 8 个可选外部记忆提供方插件，同一时间只能启用一个 |

**Hermes 的记忆体系**：
- 内置两个文件在会话开始时注入 system prompt，由 agent 用 `memory` 工具自行增删改
- 8 个外部提供方插件：honcho、openviking、mem0、hindsight、holographic、retaindb、byterover、supermemory（`memory.provider` 选择其一）
- `session_search` 用 SQLite FTS5 全文检索历史会话，文档称无 LLM 调用
- 注意：记忆是项目上下文，不是凭证保险库

来源：<https://hermes-agent.nousresearch.com/docs/user-guide/features/memory>、<https://hermes-agent.nousresearch.com/docs/user-guide/features/memory-providers>

### 中间态：上下文压缩

部分工具虽无持久记忆，但有会话内上下文管理：

| Agent | 方式 |
|-------|------|
| OpenCode | 自动压缩长对话，防止 token 爆炸 |
| Claude Code | 1M 上下文，靠大窗口硬撑 |
| omp | Hindsight Memory（项目级知识保留） |

## 关键问题

1. **记忆粒度**：是存整段对话，还是提取结构化知识？
2. **检索方式**：关键词匹配 vs 语义向量搜索
3. **隐私风险**：记忆中是否可能存入敏感信息（密钥、密码）？
4. **记忆衰减**：旧记忆如何淘汰？是否有置信度机制？

## 待补充

- [ ] 外部记忆提供方的存储格式和检索延迟
- [ ] omp Hindsight Memory 的详细机制
- [ ] 记忆对 token 消耗的影响
