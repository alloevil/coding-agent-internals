# Benchmarks

可复现的测试用例。

## 快速开始

```bash
# 1. 克隆测试仓库（大仓库）
git clone --depth 1 https://github.com/nicolo-ribaudo/tc39-proposal-signals tc39-signals

# 2. 运行搜索 benchmark
./search-bench.sh

# 3. 运行编辑 benchmark
./edit-bench.sh
```

## Benchmark 1: 搜索性能

### 测试场景

在大仓库中搜索一个不常见的字符串，测量端到端延迟。

### 测试命令

```bash
# 搜索 "useSyncExternalStore" 在 React 仓库中
# React 仓库约 15K 文件

# rg shell 调用
time rg "useSyncExternalStore" /path/to/react --count

# omp 内嵌 ripgrep（需在 omp 内部触发）
# 通过 omp 的 search 工具调用
```

### 预期结果

| 指标 | rg shell 调用 | omp 内嵌 ripgrep |
|------|-------------|-----------------|
| 首次搜索 | ~200ms | ~50ms（无 fork） |
| 10 次连续搜索 | ~2s（10 次 fork） | ~300ms（线程池复用） |

### 变量控制

- 仓库大小：1K / 5K / 15K / 50K 文件
- 搜索模式：固定字符串 / 正则
- 冷启动 vs 热缓存

## Benchmark 2: 编辑成功率

### 测试场景

模拟 AI 模型输出的常见编辑失败场景。

### 测试用例

```python
# 用例 1: Whitespace 不匹配
# 文件内容：4 空格缩进
# 模型输出：Tab 缩进
# 预期：纯文本替换失败，hash 锚定成功

# 用例 2: Stale file
# 先读文件 → 另一个进程修改文件 → 尝试编辑
# 预期：纯文本替换静默覆盖，hash 锚定拒绝执行

# 用例 3: 字符串不唯一
# 文件中有 3 处相同的 "return null"
# 预期：纯文本替换可能替换错误位置
```

### 测试脚本

```bash
#!/bin/bash
# edit-bench.sh - 编辑成功率测试

set -e

TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# 用例 1: Whitespace 不匹配
cat > test.py << 'EOF'
def hello():
    return "world"
EOF

# 模型输出（Tab 缩进）
MODEL_OUTPUT='def hello():\n\treturn "universe"'

# 纯文本替换测试
python3 -c "
content = open('test.py').read()
old = '    return \"world\"'
new = '\treturn \"universe\"'
if old in content:
    print('✅ 纯文本替换：匹配成功')
else:
    print('❌ 纯文本替换：匹配失败（whitespace 不匹配）')
"

# 用例 2: Stale file
cat > test.py << 'EOF'
def hello():
    return "world"
EOF

# 模拟读取
ORIGINAL=$(cat test.py)

# 模拟外部修改
echo 'def hello():
    return "modified"' > test.py

# 模拟纯文本替换（基于旧内容）
python3 -c "
old_content = '''def hello():
    return \"world\"'''
new_content = '''def hello():
    return \"replaced\"'''
current = open('test.py').read()
if old_content in current:
    result = current.replace(old_content, new_content)
    open('test.py', 'w').write(result)
    print('⚠️  纯文本替换：静默覆盖了外部修改！')
else:
    print('✅ 纯文本替换：旧内容不存在，匹配失败（stale file 被发现）')
"

echo "当前文件内容："
cat test.py

# 清理
rm -rf "$TEST_DIR"
```

## Benchmark 3: Token 消耗

### 测试场景

同一个编辑任务，比较不同编辑方式的输出 token 数。

### 测试用例

```python
# 任务：在 100 行文件的第 50 行插入一行注释

# 纯文本替换：需要输出完整目标行（约 50-80 tokens）
# Hash 锚定：只需输出 hash 值 + 新内容（约 20-30 tokens）
# 预期：Hash 锚定节省 40-60% 输出 token
```

## Benchmark 4: 子代理并行效率

### 测试场景

4 个独立子任务，比较串行 vs 并行执行时间。

### 测试任务

```
任务 1: 重命名模块 A 中的函数
任务 2: 更新模块 B 的测试
任务 3: 生成模块 C 的文档
任务 4: 修复模块 D 的 lint 错误
```

### 预期结果

| 模式 | 总时间 | 效率提升 |
|------|--------|---------|
| 串行执行 | 100% | 基线 |
| 2 并行 | ~55% | 1.8x |
| 4 并行 | ~30% | 3.3x |

## 方法论

- **统一硬件**：所有测试在同一台机器上运行
- **统一仓库**：使用同一 commit 的代码库
- **多次运行**：每项测试跑 3 次取中位数
- **完整日志**：记录完整日志供复现
- **公开脚本**：测试脚本在本目录下可直接运行

## 贡献 Benchmark

1. 在本目录下创建测试脚本
2. 运行并记录结果
3. 更新本文档
4. 提交 PR
