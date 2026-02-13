# Git Command Line Cheatsheet
A quick reference for common day-to-day Git workflows.

## Setup & identity
```bash
# One-time identity (used for commits)
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# Check your config
git config --list
```

## Repo basics
```bash
git init                # create a repo in the current directory
git status              # working tree + staging status
git add -A              # stage all changes (new/modified/deleted)
git commit -m "Message" # create a commit
```

## Viewing history
```bash
git log
git log --oneline --decorate --graph --all

git show <commit>
```

## Branches
```bash
git branch              # local branches
git branch -r           # remote-tracking branches (origin/*)
git branch -a           # all

git switch <branch>     # switch branches
git switch -c <branch>  # create + switch

git branch -d <branch>  # delete (safe)
git branch -D <branch>  # delete (force)
```

## Remotes
```bash
git remote -v

git remote add origin <url>
git remote set-url origin <url>
```

## Fetch vs pull
```bash
git fetch origin        # download updates into origin/*, no working-tree changes

# inspect what changed after fetching
git log --oneline main..origin/main

git pull                # fetch + integrate into current branch (merge by default)
git pull --rebase       # fetch + rebase current branch on top of remote
```

## Pushing
```bash
git push                # push current branch to its upstream (if set)
git push -u origin main # first push: set upstream tracking
```

## Staging / unstaging
```bash
git add <file>
git restore --staged <file>  # unstage (keep working copy changes)

git diff                    # unstaged vs staged? (working tree vs index)
git diff --staged           # staged vs last commit
```

## Undoing changes (careful)
```bash
git restore <file>       # discard working-copy changes to file

git revert <commit>      # create a new commit that undoes an old commit (safe for shared branches)

git reset --soft HEAD~1  # undo last commit, keep changes staged

git reset --mixed HEAD~1 # undo last commit, keep changes unstaged (default)

git reset --hard HEAD~1  # DANGER: discard commit + working changes
```

## Stash (temporary shelf)
```bash
git stash push -m "wip"
git stash list
git stash pop            # re-apply and remove
```

## Merging & rebasing
```bash
# merge <branch> into current branch
git merge <branch>

# rebase current branch on top of <base>
git rebase <base>

# resolve conflicts, then:
git add -A
git rebase --continue
```

## Tags
```bash
git tag                  # list tags
git tag v1.0.0           # create lightweight tag
git push --tags          # push tags
```

## Useful inspection
```bash
git blame <file>

git reflog               # recovery log for HEAD movements (great for "oops" moments)
```

## Common patterns
### Update your branch safely
```bash
git fetch origin
git log --oneline --decorate --graph main..origin/main
# then choose:
git merge origin/main
# or:
git rebase origin/main
```

### Clone over SSH
```bash
git clone git@github.com:OWNER/REPO.git
```

## Quick glossary
- **Working tree**: your files on disk
- **Index / Staging area**: what will go into the next commit
- **Local branch**: a branch name in your repo (e.g. `main`)
- **Remote-tracking branch**: your local snapshot of a remote branch (e.g. `origin/main`)
