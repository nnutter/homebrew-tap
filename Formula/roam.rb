class Roam < Formula
  desc "Manage dotfiles with a bare Git repository"
  homepage "https://github.com/nnutter/roam"
  url "https://github.com/nnutter/roam/archive/refs/tags/v2.0-alpha1.tar.gz"
  sha256 "2ab432060aef5749b8632d7bccf97fc3841d388cb7eeba0a348047a1e7a76b79"
  license "MIT"
  head "https://github.com/nnutter/roam.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:)

    zsh_completion.mkpath
    system bin/"roam", "generate", "zsh", "--out", zsh_completion

    (bash_completion/"roam").write <<~EOS
      complete -F _git roam
    EOS
  end

  test do
    assert_match "Use roam like git", shell_output("#{bin}/roam --help")
    assert_match "Initialize the dotfiles repository", shell_output("#{bin}/roam setup -h")

    assert_match "#compdef roam", (zsh_completion/"_roam").read
    assert_match "_git", (zsh_completion/"_roam").read
    assert_match "complete -F _git roam", (bash_completion/"roam").read
  end
end
