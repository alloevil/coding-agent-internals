# 代码编辑 — 实现方式对比

## 三个层次

### Level 1: 纯文本替换

Agent 用字符串匹配定位目标代码，执行 `str_replace`。

| Agent | 实现方式 |
|-------|---------|
| Claude Code | Read/Write 工具，纯文本替换 |
| Codex | 纯文本替换 |
| Hermes | 纯文本替换 |
| OpenCode | 纯文本替换 |
| Cursor | 基于 VS Code 编辑 API |

**典型失败场景**：
- **Whitespace 战争**：模型输出的缩进与文件不匹配，`str_replace` 失败
- **Stale file**：文件已被修改，模型基于旧内容替换，静默覆盖新内容
- **字符串不唯一**：目标代码在文件中出现多次，匹配到错误位置

### Level 2: Diff + 行号定位

Agent 生成 diff patch，用行号定位插入/替换位置。

| Agent | 实现方式 |
|-------|---------|
| Aider | 生成 diff，git apply |

**优点**：比纯文本替换更精确，支持多处同时修改
**缺点**：行号在文件变化后会漂移；仍受 whitespace 问题困扰

### Level 3: Hash 锚定 + AST 感知

用内容的 hash 值作为锚点定位代码，结合 AST 理解代码结构。

| Agent | 实现方式 |
|-------|---------|
| omp | Hash 锚定编辑（hashline）+ ast_edit + ast_grep |

**Hash 锚定原理**：
1. 读取文件时，为每行生成内容 hash
2. 编辑时，模型引用 hash 而非行号或文本
3. 如果文件已被修改（hash 不匹配），拒绝执行 patch，防止覆盖
4. Grok 4 Fast 实测：hash 锚定比传统 diff 节省 61% 输出 token

**AST 感知编辑**：
- 理解代码结构（函数、类、块），不只做文本替换
- 支持结构性重写（如"重命名这个函数的所有调用点"）
- 基于 tree-sitter 实现

## 对比总结

| 维度 | 纯文本替换 | Diff+行号 | Hash+AST |
|------|-----------|----------|---------|
| 精确度 | 低 | 中 | 高 |
| whitespace 问题 | 严重 | 中等 | 无 |
| stale file 保护 | 无 | 无 | 有（hash 校验） |
| token 效率 | 低 | 中 | 高（hash 短于文本） |
| 实现复杂度 | 低 | 中 | 高 |
| 支持 agent 数量 | 大多数 | 少数 | 仅 omp |

## 待补充

- [ ] omp hashline 的具体格式和协议
- [ ] 各 agent 编辑成功率 benchmark
- [ ] 大函数（>100 行）编辑的对比
