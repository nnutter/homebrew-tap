class GitWt < Formula
  desc "Manage Git worktrees using a consistent naming convention"
  homepage "https://github.com/nnutter/git-wt"
  url "https://github.com/nnutter/git-wt/archive/refs/tags/v0.3.tar.gz"
  sha256 "2a57aea864042605cfed64dd800d3a3818f500d11600f0d00f561347da64eb7b"
  license "MIT"
  head "https://github.com/nnutter/git-wt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
    assert_match "Manage Git worktrees", shell_output("#{bin}/git-wt --help")
  end
end
