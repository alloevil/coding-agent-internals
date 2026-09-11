#!/bin/bash
# edit-bench.sh - 编辑成功率测试
set -e

TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"
echo "测试目录: $TEST_DIR"

echo ""
echo "=== 用例 1: Whitespace 不匹配 ==="
cat > test.py << 'EOF'
def hello():
    return "world"
EOF

# Tab 缩进的锚点（文件用 4 空格缩进）
python3 -c "
content = open('test.py').read()
old = '	return \"world\"'
new = '	return \"universe\"'
if old in content:
    open('test.py', 'w').write(content.replace(old, new))
    print('✅ 纯文本替换：匹配成功')
else:
    print('❌ 纯文本替换：匹配失败（whitespace 不匹配）')
"
echo "文件内容："
cat test.py

echo ""
echo "=== 用例 2: Stale file ==="
cat > test.py << 'EOF'
def hello():
    return "world"
EOF

# 外部修改：在文件末尾追加一个函数
cat >> test.py << 'EOF'

def extra():
    return "external change"
EOF

echo "外部修改后的文件："
cat test.py

python3 -c "
# 模型读取时拿到的副本（stale buffer）
stale = '''def hello():
    return \"world\"
'''
old = '    return \"world\"'
new = '    return \"replaced\"'
buffer = stale
if old in buffer:
    buffer = buffer.replace(old, new)
    open('test.py', 'w').write(buffer)
    print('⚠️  纯文本替换：在旧副本上替换并整份写回——外部新增的 extra() 已被静默覆盖')
else:
    print('✅ 纯文本替换：旧内容不存在，匹配失败（stale file 被发现）')
"

echo "当前文件内容："
cat test.py

echo ""
echo "=== 用例 3: 字符串不唯一 ==="
cat > test.py << 'EOF'
def a():
    return null

def b():
    return null

def c():
    return null
EOF

python3 -c "
content = open('test.py').read()
count = content.count('    return null')
print(f'\"return null\" 出现次数: {count}')
if count > 1:
    print('⚠️  纯文本替换：多处匹配，可能替换错误位置')
"

rm -rf "$TEST_DIR"
echo ""
echo "测试完成"
