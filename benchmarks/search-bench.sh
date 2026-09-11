#!/bin/bash
# search-bench.sh - 搜索延迟基线（Level 1: shell fork rg/grep）
#
# 用法: ./search-bench.sh [目标仓库路径] [搜索词]
# 默认: ./tc39-signals （见 README 快速开始第 1 步）
#
# 说明: 本脚本测量的是「每次搜索 fork 一个子进程」的开销（Level 1），
#       优先用 rg，找不到 rg 时回退到 grep。Level 3（omp 的进程内 ripgrep）
#       没有命令行入口，需要在 omp 会话内触发 search 工具，无法由 shell 脚本
#       测量，因此不在本脚本输出之列。

set -u

TARGET="${1:-./tc39-signals}"
PATTERN="${2:-useSyncExternalStore}"

if [ ! -d "$TARGET" ]; then
  echo "跳过: 目标目录不存在: $TARGET"
  echo "先执行: git clone --depth 1 https://github.com/nicolo-ribaudo/tc39-proposal-signals tc39-signals"
  exit 0
fi

if ! command -v rg >/dev/null 2>&1 && ! command -v grep >/dev/null 2>&1; then
  echo "跳过: 既未找到 rg 也未找到 grep"
  exit 0
fi

python3 - "$TARGET" "$PATTERN" <<'PY'
import os, shutil, subprocess, sys, time

target, pattern = sys.argv[1], sys.argv[2]
regex = r"func[a-z]*\([^)]*string"

tool = shutil.which("rg") or shutil.which("grep")
version = subprocess.run([tool, "--version"], capture_output=True, text=True).stdout.splitlines()[0]

if tool.endswith("rg"):
    file_count = len(subprocess.run([tool, "--files", target], capture_output=True, text=True).stdout.splitlines())
    prefix, fixed_args, regex_args = ["--count"], ["-F", "--", pattern], ["-e", regex]
else:
    file_count = sum(len(files) for _, _, files in os.walk(target))
    prefix, fixed_args, regex_args = ["-r", "-c"], ["-F", "--", pattern], ["-E", "-e", regex]

print(f"目标: {target} （{file_count} 个文件）")
print(f"工具: {version}")
print("")

def bench(label, args):
    times = []
    for i in range(10):
        start = time.perf_counter()
        subprocess.run([tool, *prefix, *args, target], capture_output=True)
        elapsed_ms = (time.perf_counter() - start) * 1000
        times.append(elapsed_ms)
        if i == 0:
            print(f"  {label}: 第 1 次（冷启动） {elapsed_ms:.0f} ms")
    total = sum(times)
    print(f"  {label}: 10 次连续 {total:.0f} ms，平均 {total / 10:.0f} ms")

print(f"固定字符串搜索（{pattern}）")
bench("固定字符串", fixed_args)
print("")
print("正则搜索")
bench("正则", regex_args)
print("")
print("注: 以上是 shell fork 的开销基线；omp 的进程内 ripgrep 列需在 omp 内部触发，本脚本不测量。")
PY
