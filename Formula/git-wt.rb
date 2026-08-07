class GitWt < Formula
  desc "Manage Git worktrees using a consistent naming convention"
  homepage "https://github.com/nnutter/git-wt"
  url "https://github.com/nnutter/git-wt/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "21630077f21413c1f61885323b93800e0c6159c2e101601c510fc92756370449"
  license "MIT"
  head "https://github.com/nnutter/git-wt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  def caveats
    <<~EOS
      Optional zsh wrapper (wt):
        git-wt generate zsh
        # or: git-wt generate zsh --name wt --out $XDG_DATA_HOME/zsh/site-functions --force

      Ensure the output directory is on fpath, then restart zsh or run compinit.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-wt --version")
    assert_match "Manage Git worktrees", shell_output("#{bin}/git-wt --help")
  end
end
