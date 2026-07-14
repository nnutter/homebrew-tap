# nnutter/tap

Personal Homebrew tap.

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
