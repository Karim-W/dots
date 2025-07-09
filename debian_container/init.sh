#!/bin/bash


echo "Copying config files..."
cp ../common/.zshrc ~/.zshrc

mkdir -p ~/.config

cp ../spaceship.toml ~/.config/spaceship.toml
cp -r ../common/nvim ~/.config
cp -r ../common/tmux ~/.config
