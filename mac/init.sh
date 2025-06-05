#!/bin/bash

set -e

## Check for Homebrew installation
echo "Checking for Homebrew installation..."

if command -v brew >/dev/null 2>&1; then
  echo "Homebrew is installed"
else
  echo "Homebrew is not installed"
  read -p "Do you want to install it now? (y/n): " answer
  if [[ "$answer" == [Yy] ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Skipping installation."
  fi
fi

## Check for zsh installation
echo ""
echo "Checking for zsh installation..."

if command -v zsh >/dev/null 2>&1; then
  echo "zsh is installed"
else
  echo "zsh is not installed"
  read -p "Do you want to install it now? (y/n): " answer
  if [[ "$answer" == [Yy] ]]; then
    brew install zsh
    echo "zsh installed successfully."
  else
    echo "Skipping installation."
  fi
fi


## Check for oh-my-zsh installation
echo ""
echo "Checking for Oh My Zsh installation..."


if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh My Zsh is installed"
else
  echo "Oh My Zsh is not installed"
  read -p "Do you want to install it now? (y/n): " answer
  if [[ "$answer" == [Yy] ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    echo "Skipping installation."
  fi
fi



missing=()

check_or_install() {
  local name=$1
  local cmd=$2
  local brew_pkg=${3:-$2}

  echo ""
  echo "Checking for $name installation..."

  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "$name is not installed."
    missing+=("$name")
    read -p "Do you want to install $name via Homebrew? (y/n): " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
      if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew is not installed. Please install Homebrew first."
        exit 1
      fi
      echo "Installing $name..."
      brew install "$brew_pkg"
    else
      echo "Skipping $name installation."
    fi
  else
    echo "$name is installed"
  fi
}

check_or_install "Zsh" zsh
check_or_install "tmux" tmux
check_or_install "Neovim" nvim
check_or_install "Ghostty" ghostty
check_or_install "Spaceship" spaceship

echo ""

if [ ${#missing[@]} -eq 0 ]; then
  echo "All dependencies are already installed."
  read -p "Do you want to copy config files? (y/n): " cfg
  if [[ "$cfg" =~ ^[Nn]$ ]]; then
    echo "Exiting without copying configs."
    exit 0
  fi

  echo "Copying config files..."
  cp ../common/.zshrc ~/.zshrc

  mkdir -p ~/.config

  cp -r ../common/nvim ~/.config
  cp -r ../common/tmux ~/.config
  cp -r ../common/ghostty ~/.config
  cp -r ./zed ~/.config

else
  echo "Some dependencies were missing or skipped: ${missing[*]}"
fi
