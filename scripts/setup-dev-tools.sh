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

install_cask() {
  local cask="$1"

  echo "Installing cask: ${cask}..."
  if brew install --cask "$cask"; then
    echo "Installed cask: ${cask}"
  else
    echo "Failed to install cask: ${cask}; skipping."
  fi
}

install_formula() {
  local formula="$1"

  echo "Installing formula: ${formula}..."
  if brew install "$formula"; then
    echo "Installed formula: ${formula}"
  else
    echo "Failed to install formula: ${formula}; skipping."
  fi
}

install_cask cursor

# Claude: prefer CLI (Homebrew formula) rather than the Claude desktop app (cask).
# Note: if Homebrew doesn't have a CLI formula named "claude" on your system,
# this will fail and the script will continue.
install_formula claude

install_cask warp

echo "Done. (Any failed installs were skipped.)"
