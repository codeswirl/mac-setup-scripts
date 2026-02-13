#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$ROOT_DIR/scripts"

usage() {
  cat <<'EOF'
Usage:
  ./run.sh <command> [args]

Commands:
  list                         List available commands
  dev-tools                    Run scripts/setup-dev-tools.sh
  github-ssh-key [email] [name] Run scripts/generate-github-ssh-key.sh
  help                         Show this help

Examples:
  ./run.sh install-dev-tools
  ./run.sh github-ssh-key you@example.com
  ./run.sh github-ssh-key you@example.com id_ed25519_github_work
EOF
}

list_commands() {
  echo "Available commands:"
  echo "  install-dev-tools"
  echo "  github-ssh-key"
}

cmd="${1:-help}"
shift || true

case "$cmd" in
  help|-h|--help)
    usage
    ;;
  list)
    list_commands
    ;;
  dev-tools)
    exec "$SCRIPTS_DIR/setup-dev-tools.sh" "$@"
    ;;
  github-ssh-key)
    exec "$SCRIPTS_DIR/generate-github-ssh-key.sh" "$@"
    ;;
  *)
    echo "Unknown command: $cmd" >&2
    echo >&2
    usage >&2
    exit 2
    ;;
esac
