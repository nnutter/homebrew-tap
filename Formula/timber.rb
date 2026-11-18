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
      url "https://github.com/nnutter/timber/releases/download/v0.25.5/timber_v0.25.5_darwin_arm64.tar.gz"
      sha256 "2961774dd3a42ff7b81b297af43f20133dbd838bcd1fd008d027a1e1f56c42f9"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.25.5/timber_v0.25.5_darwin_amd64.tar.gz"
      sha256 "520c1dc95f0a1642f3d926ecb2cf209269f9a5df08e4535c5b16cde6688a536e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/timber/releases/download/v0.25.5/timber_v0.25.5_linux_arm64.tar.gz"
      sha256 "da1556bcbc704f48284a7ee82b64e8b99a0834de0c3685092aa96dd7f4845983"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.25.5/timber_v0.25.5_linux_amd64.tar.gz"
      sha256 "cd86966bdf19e6e9a65a1d5835041956eeeee1c69c08ce74cdcc67fa56b82b5f"
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
