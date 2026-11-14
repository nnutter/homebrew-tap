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
      url "https://github.com/nnutter/timber/releases/download/v0.25.0/timber_v0.25.0_darwin_arm64.tar.gz"
      sha256 "db598a5d96e85c1bc8f8d15bf4b3c1349463df8b36817d46478a837ce8880686"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.25.0/timber_v0.25.0_darwin_amd64.tar.gz"
      sha256 "7a769afddb2a99d28a7a38e973c863ff0376715bfebc47001cdaf05130949b2e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/timber/releases/download/v0.25.0/timber_v0.25.0_linux_arm64.tar.gz"
      sha256 "76c4723d2ee4682674934cf37c6656b888926e3b033a791c5a5f0e55f471b24c"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.25.0/timber_v0.25.0_linux_amd64.tar.gz"
      sha256 "4c1dcb026755f7821c1e1469ec9873cf8473bcf35de01bd705d738c7db2707cc"
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
