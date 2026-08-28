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

# Tab 缩进的替换（文件用空格）
python3 -c "
content = open('test.py').read()
old = '    return \"world\"'
new = '	return \"universe\"'  # Tab
if old in content:
    print('✅ 纯文本替换：匹配成功')
else:
    print('❌ 纯文本替换：匹配失败（whitespace 不匹配）')
"

echo ""
echo "=== 用例 2: Stale file ==="
cat > test.py << 'EOF'
def hello():
    return "world"
EOF

# 外部修改
echo 'def hello():
    return "modified"' > test.py

python3 -c "
old_content = '    return \"world\"'
current = open('test.py').read()
if old_content in current:
    print('⚠️  纯文本替换：旧内容仍存在（应该被修改了）')
else:
    print('✅ 纯文本替换：发现文件已变更')
"

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
