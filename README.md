# nnutter/homebrew-tap

Personal Homebrew tap.

## Enable tap

```bash
brew tap nnutter/tap
```

## Update a formula release

Pass a GitHub tag archive URL to download the release, calculate its SHA-256,
and update the corresponding formula:

```bash
mise run update -- https://github.com/nnutter/git-wt/archive/refs/tags/v0.5.tar.gz
```
