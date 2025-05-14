#!/bin/bash

set -e

sudo apt update

# 定义你要安装的包列表
packages=(
    htop
    tmux
    vim
    git
    curl
    wget
    unzip
    cmake
    build-essential
    neofetch
)

# 遍历列表，判断是否已安装
for pkg in "${packages[@]}"; do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
        echo "[✔] $pkg 已安装，跳过"
    else
        echo "[➤] 安装 $pkg ..."
        sudo apt install -y "$pkg"
    fi
done

# 安装 Python3 和 pip3（如果未安装）
if ! command -v python3 >/dev/null 2>&1; then
	    echo "📦 安装 Python3..."
	        sudo apt install -y python3
	else
		    echo "✅ Python3 已安装: $(python3 --version)"
fi

if ! command -v pip3 >/dev/null 2>&1; then
	    echo "📦 安装 pip3..."
	        sudo apt install -y python3-pip
	else
		    echo "✅ pip3 已安装: $(pip3 --version)"
fi

# 安装 virtualenv 并设置虚拟环境
if ! python3 -m virtualenv --version >/dev/null 2>&1; then
	    echo "📦 安装 virtualenv..."
	        pip3 install virtualenv
fi

if [ ! -d "venv" ]; then
	    echo "🐍 创建 Python 虚拟环境 venv..."
	        python3 -m virtualenv venv
fi

echo "🔄 启动 Python 虚拟环境..."
source venv/bin/activate

# 安装 requirements.txt 中的依赖
if [ -f "requirements.txt" ]; then
	    	echo "📦 安装 Python 依赖..."
	        pip3 install -r requirements.txt
	else
		    echo "⚠️ 未发现 requirements.txt，跳过 Python 依赖安装"
fi

echo ""
echo "🚀 开始安装 Yazi 文件管理器..."

# 安装 Yazi 依赖
sudo apt install -y libxcb1-dev libxkbcommon-dev pkg-config libglib2.0-dev libgtk-3-dev

# 检查 Rust 安装
if ! command -v cargo >/dev/null 2>&1; then
	    echo "📦 安装 Rust 工具链..."
	        curl https://sh.rustup.rs -sSf | sh -s -- -y
		    source "$HOME/.cargo/env"
	    else
		        echo "✅ Rust 已安装: $(cargo --version)"
fi

# 克隆并构建 Yazi
if [ ! -d "yazi" ]; then
	    echo "📥 克隆 Yazi 仓库..."
	        git clone https://github.com/sxyazi/yazi.git
fi

cd yazi

if [ ! -f "target/release/yazi" ]; then
	    echo "⚙️ 编译 Yazi..."
	        cargo build --release
	else
		    echo "✅ Yazi 已编译，跳过"
fi

# 安装 Yazi 二进制
if [ ! -f "/usr/local/bin/yazi" ]; then
	    echo "📂 安装 Yazi 到 /usr/local/bin..."
	        sudo cp target/release/yazi /usr/local/bin/
	else
		    echo "✅ Yazi 已安装到 /usr/local/bin"
fi

echo ""
echo "✅ 所有安装完成，你现在可以运行 yazi 或激活 Python 环境！"

