# Sync Main Branch

Switch to the main branch and pull the latest changes from remote.

## Steps

1. Stash any uncommitted changes if present (to avoid conflicts)
2. Switch to the `main` branch
3. Pull the latest changes from remote origin
4. Report the current status

## Execution

```bash
git stash --include-untracked (if there are changes)
git checkout main
git pull origin main
git stash pop (if we stashed)
```

Report back with:
- Whether the switch was successful
- Number of new commits pulled (if any)
- Current HEAD commit summary
