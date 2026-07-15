# nnutter/tap

Personal Homebrew tap.

## Install git-wt

`git-wt` manages Git worktrees using a consistent naming convention.

```bash
brew tap nnutter/tap
brew install nnutter/tap/git-wt
```

Optional zsh wrapper (`wt`):

```bash
git-wt generate zsh
# or: git-wt generate zsh --name wt --out $XDG_DATA_HOME/zsh/site-functions --force
```

Ensure the output directory is on `fpath`, then restart zsh or run `compinit`.

## Install Espanso (Linux)

Espanso is a cross-platform text expander. This formula builds from source for Linux.
macOS users should use the official cask: `brew install --cask espanso`.

```bash
brew tap nnutter/tap
brew trust nnutter/tap/espanso

# For Wayland (default)
brew install nnutter/tap/espanso

# Alternatively, for X11
brew install nnutter/tap/espanso --with-x11
```

### After install

**Wayland** needs capabilities before first start (re-run after upgrades):

```bash
sudo setcap "cap_dac_override+p" "$(brew --prefix espanso)/bin/espanso"
```

Then register and start:

```bash
espanso service register
espanso start
```

### Notes

- Built with `modulo` (forms/search UI) and `vendored-tls` (rustls; no OpenSSL dependency).
- Non-US keyboard layouts on Wayland may need a `keyboard_layout` entry in
  `$CONFIG/config/default.yml`. See [Espanso docs](https://espanso.org/docs/install/linux/).
