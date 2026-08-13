# nnutter/homebrew-tap

Personal Homebrew tap.

## Enable tap

```bash
brew tap nnutter/tap
```

## Update a formula release

Give the formula name and the GitHub release tag.
The script downloads the release, calculates its SHA-256, updates the formula, and commits the change.

```bash
mise run update -- git-wt v0.5
```

The commit message looks like `Updated git-wt to v0.5`.
