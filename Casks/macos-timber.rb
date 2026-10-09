cask "macos-timber" do
  version "0.5.0"
  sha256 "c7aa41ebaa34cdfede0c29ed52f86fd8b9f39fd15e50460d39168c377bf4df16"

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
