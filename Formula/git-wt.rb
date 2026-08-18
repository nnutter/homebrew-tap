class GitWt < Formula
  desc "Manage Git worktrees using a consistent naming convention"
  homepage "https://github.com/nnutter/git-wt"
  url "https://github.com/nnutter/git-wt/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "edad5df7c5a53cbf21e3eb9dcba22cec982367dfd44cc40ffae1003e50bfa1fc"
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

    generate_completions_from_executable(bin/"git-wt", shell_parameter_format: :cobra)

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
    assert_match "#compdef git-wt", (zsh_completion/"_git-wt").read
    assert_match "bash completion V2 for git-wt", (bash_completion/"git-wt").read
    assert_match "fish completion for git-wt", (fish_completion/"git-wt.fish").read
    assert_match "powershell completion for git-wt", (pwsh_completion/"_git-wt.ps1").read
  end
end
