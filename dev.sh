#!/usr/bin/env bash

# Set the Neovim configuration path for Linux/macOS
NVIM_CONFIG_PATH="$HOME/.config/nvim"

# Remove the existing Neovim config directory if it exists
rm -rf "$NVIM_CONFIG_PATH"

# Create a symbolic link to the current directory
ln -s "$(pwd)" "$NVIM_CONFIG_PATH"

echo "Symlink created for Neovim configuration at $NVIM_CONFIG_PATH"

