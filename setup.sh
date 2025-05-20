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

# 安装neovim
if [ command -v >/dev/null 2>&1; then
  echo "neovim已安装，跳过"
else
  # 下载最新的 AppImage
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage

  # 添加执行权限
  chmod u+x nvim-linux-x86_64.appimage

  # 移动到全局可用目录（或自己 bin 目录）
  sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
fi

# 安装lazyvim
if [ -d "$HOME/.config/nvim" ] && [ -f "$HOME/.config/nvim/lazy-lock.json" ]; then
  echo "[✔] LazyVim 已安装，跳过"
else
  echo "[➤] 安装 LazyVim ..."
  if [ -d "$HOME/.config/nvim" ]; then
    mv $HOME/.config/nvim $HOME/.config/nvim.bak
    mv $HOME/.local/share/nvim $HOME/.local/share/nvim.bak
    echo "[i] 旧的 nvim 配置已备份"
  fi
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git
  echo "[✔] LazyVim 克隆完成"
fi

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

# if [ ! -d "venv" ]; then
# 	    echo "🐍 创建 Python 虚拟环境 venv..."
# 	        python3 -m virtualenv venv
# fi
#
# echo "🔄 启动 Python 虚拟环境..."
# source venv/bin/activate
#
# # 安装 requirements.txt 中的依赖
# if [ -f "requirements.txt" ]; then
# 	    	echo "📦 安装 Python 依赖..."
# 	        pip3 install -r requirements.txt
# 	else
# 		    echo "⚠️ 未发现 requirements.txt，跳过 Python 依赖安装"
# fi

echo ""
echo "🚀 开始安装 Yazi 文件管理器..."

if command -v yazi >/dev/null 2>&1; then
  echo "[✔] Yazi 已安装，跳过"
else

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
    sudo mv target/release/yazi /usr/local/bin/
  else
    echo "✅ Yazi 已安装到 /usr/local/bin"
  fi

fi

echo ""
echo "✅ 所有安装完成！"

echo ""
echo "正在复制配置文件..."
# 定义 dotfiles 目录（根据你实际放的位置修改）
DOTFILES_DIR="./dotfiles"

# 配置文件列表
FILES=(
  ".tmux.conf"
  ".bash_aliases"
)

for file in "${FILES[@]}"; do
  # 如果已经存在（无论是普通文件、旧链接、目录）
  if [ -e "$HOME/$file" ] || [ -L "$HOME/$file" ]; then
    echo "🗑 删除旧的 $file"
    rm -rf "$HOME/$file"
  fi

  # 创建新的软链接
  echo "🔗 链接 $file 到 $DOTFILES_DIR/$file"
  ln -s "$DOTFILES_DIR/$file" "$HOME/$file"
done
