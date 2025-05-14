#!/bin/bash

echo "🔧 VPS Benchmark 开始运行..."
echo "系统信息："
uname -a
echo "-----------------------------"

# CPU 性能测试
echo "🧠 CPU 压缩性能测试 (gzip -9)"
START=$(date +%s)
gzip -1 < /dev/zero | head -c 20M > /dev/null
END=$(date +%s)
echo "压缩耗时：$((END - START)) 秒"
echo "-----------------------------"

# 内存测试
echo "📊 内存读写测试 (sysbench)"
if ! command -v sysbench &> /dev/null; then
    echo "未检测到 sysbench，正在安装..."
    sudo apt update && sudo apt install -y sysbench
fi
sysbench memory run --memory-total-size=512MB --memory-block-size=1M
echo "-----------------------------"

# 磁盘测试
echo "💾 磁盘写入速度测试 (dd)"
dd if=/dev/zero of=./dd_test.tmp bs=64k count=1024 oflag=dsync
rm -f ./dd_test.tmp
echo "-----------------------------"

echo "✅ VPS Benchmark 完成！"

