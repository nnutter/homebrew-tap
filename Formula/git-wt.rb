class GitWt < Formula
  desc "Manage Git worktrees using a consistent naming convention"
  homepage "https://github.com/nnutter/git-wt"
  url "https://github.com/nnutter/git-wt/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "687ac8dbf874bdbf2c3f8befa182cc4109647f4dc08a80088a9a4f4e1543b5b6"
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

    zsh_completion.mkpath
    system bin/"git-wt", "generate", "zsh", "--out", zsh_completion
  end

  def caveats
    <<~EOS
      The wt wrapper and completion were installed in:
        #{zsh_completion}

      Ensure this directory is on fpath, then restart zsh or run compinit.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-wt --version")
    assert_match "Manage Git worktrees", shell_output("#{bin}/git-wt --help")
    assert_path_exists zsh_completion/"wt"
    assert_path_exists zsh_completion/"_wt"
  end
end
