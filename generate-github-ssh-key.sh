#!/usr/bin/env bash
set -euo pipefail

SSH_DIR="$HOME/.ssh"
KEY_NAME="${2:-id_ed25519_github}"
KEY_PATH="$SSH_DIR/$KEY_NAME"

EMAIL="${1:-}"
if [[ -z "$EMAIL" ]]; then
  read -rp "Enter the email address associated with your GitHub account: " EMAIL
fi

if [[ -z "$EMAIL" ]]; then
  echo "Error: an email address is required."
  exit 1
fi

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

if [[ -f "$KEY_PATH" || -f "${KEY_PATH}.pub" ]]; then
  read -rp "Key ${KEY_PATH} already exists. Overwrite? (y/N): " CONFIRM
  if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "Aborting without overwriting existing key."
    exit 0
  fi
fi

ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_PATH" -N ""

if ! pgrep -q ssh-agent; then
  eval "$(ssh-agent -s)"
fi

ssh-add "$KEY_PATH"

if command -v pbcopy >/dev/null 2>&1; then
  pbcopy < "${KEY_PATH}.pub"
  echo "Public key copied to clipboard."
else
  echo "pbcopy not found; public key saved to ${KEY_PATH}.pub."
fi

cat <<'EOF'
Next steps:
1. Sign in to GitHub.
2. Navigate to Settings -> SSH and GPG keys -> New SSH key.
3. Paste the copied public key, give it a descriptive title, and save.
EOF
