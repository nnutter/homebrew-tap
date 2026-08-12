class Roam < Formula
  desc "Manage dotfiles with a bare Git repository"
  homepage "https://github.com/nnutter/roam"
  url "https://github.com/nnutter/roam/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "f53233ca4e4c32c522215e81c7e5cd8673c16ef81e2fa5e2b9fc6164f28a44f8"
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
