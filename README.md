# nnutter/homebrew-tap

Personal Homebrew tap.

## Enable tap

```bash
brew tap nnutter/tap
```

## Update a formula release

Pass a GitHub tag archive URL to download the release, calculate its SHA-256,
update the corresponding formula, and commit the change:

```bash
mise run update -- https://github.com/nnutter/git-wt/archive/refs/tags/v0.5.tar.gz
```

The commit message looks like `Updated git-wt to v0.5`.
