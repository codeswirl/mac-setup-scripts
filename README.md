# mac-setup-scripts
A small collection of shell scripts to help bootstrap a fresh macOS setup.

## Prereqs
- macOS
- A terminal (Warp, Terminal.app, iTerm2, etc.)

## Scripts
Shell scripts live in `scripts/`. For convenience, use `run.sh` from the repo root to run common tasks.

### Quick start (recommended)
```bash
chmod +x run.sh
./run.sh list
```

### Available commands
#### Install apps via Homebrew
Installs Homebrew (if missing) and then installs:
- Cursor (cask)
- Claude CLI (formula; will be skipped if unavailable)
- Warp (cask)

```bash
./run.sh dev-tools
```

#### Generate an SSH key for GitHub (supports multiple profiles)
Generates an `ed25519` SSH key you can add to GitHub as an **Authentication Key**.

This script supports multiple GitHub accounts by creating a profile-specific key and (by default) writing an SSH config host alias.

Defaults:
- Profile: `default`
- Key path: `~/.ssh/id_ed25519_github_<profile>`
- SSH host alias: `github.com-<profile>`

Run interactively (prompts for email):
```bash
./run.sh github-ssh-key
```

Personal profile:
```bash
./run.sh github-ssh-key --profile personal --email you@gmail.com
```

Work profile:
```bash
./run.sh github-ssh-key --profile work --email you@company.com
```

Optional: choose a different key filename:
```bash
./run.sh github-ssh-key --profile work --email you@company.com --key-name id_ed25519_github_work
```

After running, the script copies your public key to the clipboard (when available). Add it in GitHub:
Settings → **SSH and GPG keys** → **New SSH key** → Key type: **Authentication Key**.

Use the profile with git remotes by using the SSH host alias in your URLs:
```bash
git clone git@github.com-work:OWNER/REPO.git
# or update an existing remote:
git remote set-url origin git@github.com-personal:OWNER/REPO.git
```

Test SSH auth for a profile:
```bash
ssh -T git@github.com-work
```

### Running scripts directly (no wrapper)
You can also run the scripts in `scripts/` directly:

```bash
chmod +x scripts/setup-dev-tools.sh scripts/generate-github-ssh-key.sh
./scripts/setup-dev-tools.sh
./scripts/generate-github-ssh-key.sh --profile personal --email you@gmail.com
```

## Git cheatsheet
See `cheatsheet.md` for a quick reference of common Git CLI commands.

## Notes
- These scripts are intended to be idempotent-ish: Homebrew installs will generally no-op if already installed.
- SSH key generation will ask before overwriting an existing key file.
