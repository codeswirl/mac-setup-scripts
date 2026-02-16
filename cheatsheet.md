#Test Header


# Git CLI Cheatsheet (the commands you’ve been using)
A practical list of Git + shell commands you’ve been asking about.

## Use this for a Visual
git log --oneline --graph --decorate --all

##To branch off another branch:

git switch -c new-branch existing-branch


## Shell basics (macOS)
```bash
ls                 # list files
ls -la             # detailed list (incl dotfiles)

touch file.txt     # create an empty file (or update its timestamp)
rm file.txt        # delete a file

nano file.txt      # edit a file in the terminal
```

## See what’s going on ->
```bash
git status         # most useful command: staged/unstaged + branch info
```

## Stage changes (the “index”)
```bash
git add .          # stage changes in the current directory

git diff           # see unstaged changes

git diff --cached  # see staged changes

git diff --name-only --cached  # list staged files only
```

## Commit
```bash
git commit -m "message"   # commit what’s staged
```

## Branches (local vs remote)
```bash
git branch         # list local branches

git branch -r      # list remote-tracking branches (origin/*)

git branch -a      # list all (local + remote-tracking)

git branch -vv     # show each local branch + its upstream (tracking) + ahead/behind
```

## Switching / creating branches
```bash
git switch main                 # switch to main

git switch -c test-branch       # create a new local branch from your current HEAD

# create a new local branch from the remote main (good when you want latest remote state)
git fetch origin

git switch -c my-branch origin/main
```

## Upstream (tracking) in one minute
- Your local branch can “track” a remote branch (its **upstream**), like `main` → `origin/main`.
- When upstream is set, plain `git push` and `git pull` know where to push/pull.

Useful commands:
```bash
# show the upstream for the current branch (errors if none)
git rev-parse --abbrev-ref @{u}

# set upstream the first time you push a new branch
git push -u origin test-branch
```

## Fetch vs pull
```bash
git fetch          # download updates into origin/* (does NOT change your files)

git pull           # fetch + integrate into your current branch

git pull --ff-only # update only if it can fast-forward (no merge commit)
```

## Clean up remote-tracking branches
```bash
git fetch -p        # prune deleted remote branches from origin/* locally
```

## Push
```bash
git push                 # push to your branch’s upstream (if set)

git push origin main     # push a specific local branch to origin

git push -u origin main  # push + set upstream (common on first push)

git push origin test-branch
```

## Delete branches
### Delete a local branch
You can’t delete the branch you’re currently on—switch off it first.

```bash
git switch main

git branch -d test-branch   # safe delete (only if merged)

git branch -D test-branch   # force delete
```

### Delete a remote branch
```bash
git push origin --delete my-feature-branch
```

## Remotes
```bash
git remote -v         # see remote URLs

git remote show origin # see what branches/tracking info origin has
```

## Repo setup / clone (common when bootstrapping)
```bash
git init

git remote add origin git@github.com:OWNER/REPO.git

git fetch origin

git clone git@github.com:OWNER/REPO.git
```
