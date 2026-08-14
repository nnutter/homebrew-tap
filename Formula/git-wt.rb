class GitWt < Formula
  desc "Manage Git worktrees using a consistent naming convention"
  homepage "https://github.com/nnutter/git-wt"
  url "https://github.com/nnutter/git-wt/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "63d94523662cfc21576bff3d37ec39bf12a6bb8d2a560bfda13a563d9358b3ee"
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
