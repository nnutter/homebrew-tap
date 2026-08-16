class Roam < Formula
  desc "Manage dotfiles with a bare Git repository"
  homepage "https://github.com/nnutter/roam"
  url "https://github.com/nnutter/roam/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "12eee0148f2d95647d764d6d1e6e48aff9ac0391bcbc7cfc6620c1e04c8dbba8"
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
