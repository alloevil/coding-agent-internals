# 代码搜索 — 实现方式对比

## 三个层次

### Level 1: Shell 调用外部工具

Agent fork 一个子进程执行 `rg` 或 `grep`，解析 stdout 输出。

| Agent | 实现方式 |
|-------|---------|
| Claude Code | `rg` shell 调用 |
| Hermes | `rg` shell 调用 |
| Aider | `rg` shell 调用 |
| OpenCode | `rg` shell 调用 |

**优点**：实现简单，依赖外部 rg 二进制
**缺点**：每次搜索一次 fork/exec，大仓库中有进程创建开销；输出需解析为结构化数据

### Level 2: IDE 原生搜索

IDE 内置的搜索能力，通常基于自身索引系统。

| Agent | 实现方式 |
|-------|---------|
| Cursor | VS Code 搜索引擎 |
| Windsurf | VS Code 搜索引擎 |
| Copilot | IDE 搜索 API |

**优点**：与编辑器深度集成，可直接跳转到结果
**缺点**：受限于 IDE 环境，不可在终端独立使用

### Level 3: 进程内嵌引擎（零 fork）

把搜索引擎直接编译进 Agent 进程，通过函数调用而非子进程通信。

| Agent | 实现方式 | 代码量 |
|-------|---------|--------|
| omp | Rust 内嵌 ripgrep（grep 模块） | ~1,900 行 Rust |
| omp | Rust 内嵌 brush shell（shell 模块） | ~3,700 行 Rust |

**优点**：无 fork/exec 开销；输出直接是内存中的结构化数据；跨平台无需外部依赖
**缺点**：实现复杂，需要维护 Rust 代码

## 性能影响

| 场景 | Level 1 (shell rg) | Level 3 (内嵌 ripgrep) |
|------|-------------------|----------------------|
| 小仓库（<100 文件） | 差异不明显 | 差异不明显 |
| 大仓库（>10K 文件） | 进程创建开销累积 | 内存函数调用，显著更快 |
| 并发搜索 | N 个子进程 | 共享进程内线程池 |

## 关键问题

1. **是否尊重 .gitignore？** rg 默认尊重；内嵌实现需自行处理
2. **是否支持 Unicode？** rg 原生支持；内嵌实现需验证
3. **输出格式？** Level 1 通常是文本解析；Level 3 直接返回结构化对象
4. **搜索失败时的降级策略？** 部分 agent 会 fallback 到 `grep` 或 `find`

## 待补充

- [ ] 各 agent 搜索的并发模型（单线程 vs 多线程）
- [ ] 大仓库 benchmark 数据（10K+ 文件）
- [ ] 是否支持 AST-aware 搜索（如 omp 的 ast_grep）
