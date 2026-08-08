class Roam < Formula
  desc "Manage dotfiles with a bare Git repository"
  homepage "https://github.com/nnutter/roam"
  url "https://github.com/nnutter/roam/archive/refs/tags/v1.0.tar.gz"
  sha256 "109dfb2becc770dd30487d551b693995edfc161904b3afb4bc634586d1950d9b"
  head "https://github.com/nnutter/roam.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    bin.install "roam.sh" => "roam"
  end

  def caveats
    <<~EOS
      Bash completion:
        complete -F _git roam

      Zsh completion:
        #compdef roam
        compdef roam=git
    EOS
  end

  test do
    # git-sh-setup prints usage and exits 129 on -h
    assert_match "roam setup", shell_output("#{bin}/roam setup -h", 129)
  end
end
