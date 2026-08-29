class Timber < Formula
  desc "Manage Git worktrees using a consistent naming convention"
  homepage "https://github.com/nnutter/timber"
  url "https://api.github.com/repos/nnutter/timber/tarball/v0.13.2",
      user: "x-access-token:#{ENV.fetch("HOMEBREW_GITHUB_API_TOKEN")}"
  sha256 "a448e21cdc374c1231c5b714c04089753fedc8e82ca7a45f0f1e55e48d0c7727"
  license "MIT"
  head "https://github.com/nnutter/timber.git", branch: "main"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"timber", shell_parameter_format: :cobra)

    zsh_completion.mkpath
    system bin/"timber", "generate", "zsh", "--out", zsh_completion
  end

  def caveats
    <<~EOS
      The t wrapper and completion were installed in:
        #{zsh_completion}

      Ensure this directory is on fpath, then restart zsh or run compinit.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/timber --version")
    assert_match "Manage Git worktrees", shell_output("#{bin}/timber --help")
    assert_path_exists zsh_completion/"t"
    assert_path_exists zsh_completion/"_t"
    assert_match "#compdef timber", (zsh_completion/"_timber").read
    assert_match "bash completion V2 for timber", (bash_completion/"timber").read
    assert_match "fish completion for timber", (fish_completion/"timber.fish").read
    assert_match "powershell completion for timber", (pwsh_completion/"_timber.ps1").read
  end
end
