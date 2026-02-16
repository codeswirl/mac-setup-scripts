#!/usr/bin/env bash
set -euo pipefail

SSH_DIR="$HOME/.ssh"
SSH_CONFIG="$SSH_DIR/config"

usage() {
  cat <<'EOF'
Usage:
  ./scripts/generate-github-ssh-key.sh [options]

Options:
  -p, --profile NAME   Profile name (e.g. personal, work). Used to name keys + SSH host alias.
  -e, --email EMAIL    Email address associated with the GitHub account.
  -k, --key-name NAME  SSH key filename (stored under ~/.ssh/). Overrides the default.
  --no-config          Do not write an SSH config entry.
  -h, --help           Show help.

Defaults:
  profile: default
  key-name: id_ed25519_github_<profile>

Examples:
  # Personal account
  ./scripts/generate-github-ssh-key.sh --profile personal --email you@gmail.com

  # Work account
  ./scripts/generate-github-ssh-key.sh -p work -e you@company.com

  # Custom key filename
  ./scripts/generate-github-ssh-key.sh -p work -e you@company.com -k id_ed25519_github_work
EOF
}

PROFILE="default"
EMAIL=""
KEY_NAME=""
WRITE_CONFIG=1

# Backwards compatibility: allow old positional usage:
#   ./generate-github-ssh-key.sh <email> [key_name]
if [[ ${1:-} != "" && ${1:-} != -* ]]; then
  EMAIL="$1"
  shift
  if [[ ${1:-} != "" && ${1:-} != -* ]]; then
    KEY_NAME="$1"
    shift
  fi
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--profile)
      PROFILE="${2:-}"
      shift 2
      ;;
    -e|--email)
      EMAIL="${2:-}"
      shift 2
      ;;
    -k|--key-name)
      KEY_NAME="${2:-}"
      shift 2
      ;;
    --no-config)
      WRITE_CONFIG=0
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      echo >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$PROFILE" ]]; then
  echo "Error: profile name cannot be empty." >&2
  exit 1
fi

if [[ -z "$EMAIL" ]]; then
  read -rp "Enter the email address associated with your GitHub account (${PROFILE}): " EMAIL
fi

if [[ -z "$EMAIL" ]]; then
  echo "Error: an email address is required." >&2
  exit 1
fi

if [[ -z "$KEY_NAME" ]]; then
  KEY_NAME="id_ed25519_github_${PROFILE}"
fi

KEY_PATH="$SSH_DIR/$KEY_NAME"
HOST_ALIAS="github.com-${PROFILE}"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

if [[ -f "$KEY_PATH" || -f "${KEY_PATH}.pub" ]]; then
  read -rp "Key ${KEY_PATH} already exists. Overwrite? (y/N): " CONFIRM
  case "${CONFIRM:-}" in
    y|Y) ;;
    *)
      echo "Aborting without overwriting existing key."
      exit 0
      ;;
  esac
fi

ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_PATH" -N ""

if ! pgrep -q ssh-agent; then
  eval "$(ssh-agent -s)"
fi

ssh-add "$KEY_PATH" || true

if [[ $WRITE_CONFIG -eq 1 ]]; then
  touch "$SSH_CONFIG"
  chmod 600 "$SSH_CONFIG"

  # Remove any existing block for this host alias, then append a fresh one.
  # (Keeps the script re-runnable without accumulating duplicate entries.)
  TMP_FILE="$(mktemp)"
  awk -v host="${HOST_ALIAS}" '
    BEGIN { skip=0 }
    $1=="Host" && $2==host { skip=1; next }
    $1=="Host" && skip==1 { skip=0 }
    skip==0 { print }
  ' "$SSH_CONFIG" > "$TMP_FILE"
  mv "$TMP_FILE" "$SSH_CONFIG"

  cat >> "$SSH_CONFIG" <<EOF

Host ${HOST_ALIAS}
  HostName github.com
  User git
  IdentityFile ${KEY_PATH}
  IdentitiesOnly yes
EOF

  echo "Wrote SSH config entry for host alias: ${HOST_ALIAS}"
fi

if command -v pbcopy >/dev/null 2>&1; then
  pbcopy < "${KEY_PATH}.pub"
  echo "Public key copied to clipboard."
else
  echo "pbcopy not found; public key saved to ${KEY_PATH}.pub."
fi

echo
cat <<EOF
Next steps:
1. Sign in to GitHub (${PROFILE}).
2. Navigate to Settings -> SSH and GPG keys -> New SSH key.
3. Paste the copied public key, give it a descriptive title, and save.

Using this profile with git remotes:
- Use this SSH host alias in your clone/push URLs:
    git@${HOST_ALIAS}:OWNER/REPO.git

Test auth:
    ssh -T git@${HOST_ALIAS}
EOF
