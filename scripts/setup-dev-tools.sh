#!/usr/bin/env bash
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Updating Homebrew..."
brew update

echo "Installing Cursor..."
brew install --cask cursor

echo "Installing Claude..."
brew install --cask claude

echo "Installing Warp..."
brew install --cask warp

echo "All requested tools are installed."
