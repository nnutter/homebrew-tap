class Roam < Formula
  desc "Manage dotfiles with a bare Git repository"
  homepage "https://github.com/nnutter/roam"
  url "https://github.com/nnutter/roam/archive/refs/tags/v2.0-alpha1.tar.gz"
  sha256 "2ab432060aef5749b8632d7bccf97fc3841d388cb7eeba0a348047a1e7a76b79"
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
    zsh_completion.install "_roam"
  end

  test do
    # git-sh-setup prints usage and exits 129 on -h
    assert_match "roam setup", shell_output("#{bin}/roam setup -h", 129)

    assert_match "complete -F _git roam", (bash_completion/"roam").read
    assert_match "_git", (zsh_completion/"_roam").read
  end
end
