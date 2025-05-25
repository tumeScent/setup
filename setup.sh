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
  fzf
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
if command -v nvim >/dev/null 2>&1; then
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
    rustup update
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

  cargo install yazi-cli

  echo "安装yazi插件..."
  ya pkg install
  echo "yazi插件安装完成"

fi

if command -v glow >/dev/null 2>&1; then
  echo "glow已安装，跳过"
else
  echo ""
  echo "从官方仓库安装glow..."
  # Debian/Ubuntu
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
  echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
  sudo apt update && sudo apt install glow
  echo "glow安装完成"
fi
echo ""
echo "正在复制配置文件..."

# dotfiles 目录
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/dotfiles" && pwd)"

# 配置文件或目录列表（不包括整个 .config）
FILES=(
  ".tmux.conf"
  ".bash_aliases"
)

# .config 下的子目录
CONFIG_DIRS=(
  "nvim"
  "yazi"
)

# 检查 dotfiles 目录是否存在
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "❌ 错误：dotfiles 目录不存在: $DOTFILES_DIR"
  exit 1
fi

# 处理普通 dotfiles
for file in "${FILES[@]}"; do
  SOURCE="$DOTFILES_DIR/$file"
  TARGET="$HOME/$file"

  if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
    echo "🗑 删除旧的 $file"
    rm -rf "$TARGET"
  fi

  echo "🔗 链接 $file → $SOURCE"
  ln -s "$SOURCE" "$TARGET"
done

# 处理 .config 子目录
for config in "${CONFIG_DIRS[@]}"; do
  SOURCE="$DOTFILES_DIR/.config/$config"
  TARGET="$HOME/.config/$config"

  if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
    echo "🗑 删除旧的 .config/$config"
    rm -rf "$TARGET"
  fi

  echo "🔗 链接 .config/$config → $SOURCE"
  ln -s "$SOURCE" "$TARGET"
done

echo "✅ 配置文件设置完成"
