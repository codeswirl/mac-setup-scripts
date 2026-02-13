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
Installs Homebrew (if missing) and then installs the following casks:
- Cursor
- Claude
- Warp

```bash
./run.sh install-dev-tools
```

#### Generate an SSH key for GitHub
Generates an `ed25519` SSH key you can add to GitHub as an **Authentication Key**.

Default key path:
- `~/.ssh/id_ed25519_github`

Run interactively (prompts for your GitHub email):
```bash
./run.sh github-ssh-key
```

Run with email (no prompt):
```bash
./run.sh github-ssh-key you@example.com
```

Optional: choose a different key filename (2nd arg):
```bash
./run.sh github-ssh-key you@example.com id_ed25519_github_work
```

After running, the script copies your public key to the clipboard (when available). Add it in GitHub:
Settings → **SSH and GPG keys** → **New SSH key** → Key type: **Authentication Key**.

### Running scripts directly (no wrapper)
You can also run the scripts in `scripts/` directly:

```bash
chmod +x scripts/setup-dev-tools.sh scripts/generate-github-ssh-key.sh
./scripts/setup-dev-tools.sh
./scripts/generate-github-ssh-key.sh you@example.com
```

## Git cheatsheet
See `cheatsheet.md` for a quick reference of common Git CLI commands.

## Notes
- These scripts are intended to be idempotent-ish: Homebrew installs will generally no-op if already installed.
- SSH key generation will ask before overwriting an existing key file.
