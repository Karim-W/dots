#!/bin/bash

set -e

missing=()

install_aur() {
  local pkg=$1
  if command -v yay >/dev/null 2>&1; then
    yay -S --noconfirm "$pkg"
  elif command -v paru >/dev/null 2>&1; then
    paru -S --noconfirm "$pkg"
  else
    echo "No AUR helper (yay or paru) found. Install one to continue."
    exit 1
  fi
}

check_or_install() {
  local name=$1
  local cmd=$2
  local pkg=$3
  local aur=${4:-false}

  echo ""
  echo "Checking for $name installation..."

  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "$name is not installed."
    missing+=("$name")
    read -p "Install $name? (y/n): " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
      echo "Installing $name..."
      if [[ "$aur" == true ]]; then
        install_aur "$pkg"
      else
        sudo pacman -S --noconfirm "$pkg"
      fi
    else
      echo "Skipping $name."
    fi
  else
    echo "$name is installed"
  fi
}

echo "Checking core tools..."
check_or_install "Zsh" zsh zsh
check_or_install "tmux" tmux tmux
check_or_install "Neovim" nvim neovim
check_or_install "Ghostty" ghostty ghostty true

echo "Checking Wayland desktop tools..."
check_or_install "Hyprland" Hyprland hyprland true
check_or_install "Sway" sway sway
check_or_install "SwayNC" swaync swaync true
check_or_install "Waybar" waybar waybar
check_or_install "Wofi" wofi wofi

echo ""
if [ ${#missing[@]} -eq 0 ]; then
  echo "All dependencies installed."
  read -p "Copy config files to ~/.config? (y/n): " cfg
  if [[ "$cfg" =~ ^[Nn]$ ]]; then
    echo "Exiting without copying configs."
    exit 0
  fi

  echo "Copying configs..."
  cp ../common/.zshrc ~/.zshrc
  mkdir -p ~/.config

  cp -r ../common/nvim ~/.config
  cp -r ../common/tmux ~/.config
  cp -r ../common/ghostty ~/.config
  cp -r ./zed ~/.config

  for dir in hypr sway swaync waybar wofi; do
    if [ -d "./arch/$dir" ]; then
      cp -r "./arch/$dir" ~/.config
    fi
  done

else
  echo "Missing or skipped: ${missing[*]}"
fi

