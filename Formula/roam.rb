class Roam < Formula
  desc "Manage dotfiles with a bare Git repository"
  homepage "https://github.com/nnutter/roam"
  url "https://github.com/nnutter/roam/archive/refs/tags/v1.1.tar.gz"
  sha256 "37bebe2d9e7d58ad2f0134a2b686ad45a1e3df5c1242a6e80a9e6c673af08f5e"
  head "https://github.com/nnutter/roam.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    bin.install "roam.sh" => "roam"

    (bash_completion/"roam").write <<~EOS
      complete -F _git roam
    EOS
    (zsh_completion/"_roam").write <<~EOS
      #compdef roam=git
      _git "$@"
    EOS
  end

  test do
    # git-sh-setup prints usage and exits 129 on -h
    assert_match "roam setup", shell_output("#{bin}/roam setup -h", 129)

    assert_match "complete -F _git roam", (bash_completion/"roam").read
    assert_match "_git", (zsh_completion/"_roam").read
  end
end
