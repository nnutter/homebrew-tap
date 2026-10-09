cask "macos-timber" do
  version "0.4.1"
  sha256 "5a0831e1b4e3383982ea1fe7eb6eea2d8fdb7b4de2226ca3a3c5419e5a4f807a"

  url "https://github.com/nnutter/macos-timber/releases/download/v#{version}/Timber.zip"
  name "Timber"
  desc "Menu bar frontend for Git worktrees"
  homepage "https://github.com/nnutter/macos-timber"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on formula: "timber"
  depends_on macos: :sonoma

  app "Timber.app"

  uninstall quit: "io.github.nnutter.Timber"

  # No zap stanza required

  caveats do
    <<~EOS
      #{token} is ad-hoc signed and not notarized. Gatekeeper blocks a
      quarantined copy. Clear the quarantine attribute before the first launch:

        xattr -dr com.apple.quarantine "#{appdir}/Timber.app"

      Later installs can skip the attribute:

        brew reinstall --cask --no-quarantine #{token}
    EOS
  end
end
