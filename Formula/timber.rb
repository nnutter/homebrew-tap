class Timber < Formula
  desc "Manage Git worktrees"
  homepage "https://github.com/nnutter/timber"
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  head do
    url "https://github.com/nnutter/timber.git", branch: "master"
    depends_on "go" => :build
  end

  on_macos do
    on_arm do
      url "https://github.com/nnutter/timber/releases/download/v0.24.4/timber_v0.24.4_darwin_arm64.tar.gz"
      sha256 "796ccae4a7b4f89196c03d08a6a7ea36607cd27768057bcb124b8e6f2920b870"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.24.4/timber_v0.24.4_darwin_amd64.tar.gz"
      sha256 "9c48743215d7b7f0cf2c0093d0a29103ebfbf9a6ab68cd0a0a688da9bdb4d8b7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/timber/releases/download/v0.24.4/timber_v0.24.4_linux_arm64.tar.gz"
      sha256 "5252916949e0749b5a5592567d67feabe4a9942cd3a9e3c72bf019dedb5d291e"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.24.4/timber_v0.24.4_linux_amd64.tar.gz"
      sha256 "3e5bf45c95fbfc4302b0a4648de3ccfc642f9895a9fbf1ac5fa6a7a7385c90ea"
    end
  end

  def install
    if build.head?
      ldflags = %W[-X main.version=#{version}]
      system "go", "build", *std_go_args(ldflags:)
    else
      # The release archive names the binary after the archive itself.
      bin.install Dir["*"].first => "timber"
    end

    generate_completions_from_executable(bin/"timber", shell_parameter_format: :cobra)

    zsh_completion.mkpath
    system bin/"timber", "generate", "zsh", "--out", zsh_completion
  end

  def caveats
    <<~EOS
      The t wrapper (and completion) were installed in:
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
