#!/bin/bash
set -e

echo "[*] Bootstrapping dev environment..."

# Clone and init dotfiles if not present
if [ ! -f ~/.zshrc ]; then
  echo "[*] Cloning dotfiles..."
  git clone https://github.com/karim-w/dots.git ~/.dotfiles
  /bin/bash ~/.dotfiles/debian_container/init.sh
fi

# Install Go if not found
if [ ! -d "/usr/local/go" ]; then
  echo "[*] Installing Go..."
  curl -fsSL https://go.dev/dl/go1.22.3.linux-amd64.tar.gz | tar -C /usr/local -xzf -
  echo 'export PATH="/usr/local/go/bin:$PATH"' >> ~/.zshrc
fi

# Install gopls
if ! command -v gopls &>/dev/null; then
  echo "[*] Installing gopls..."
  /usr/local/go/bin/go install golang.org/x/tools/gopls@latest
fi

# Install bun, pnpm, etc... (with similar guards)

echo "[*] Dev environment ready."

sleep infinity
