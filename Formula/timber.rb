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
      url "https://github.com/nnutter/timber/releases/download/v0.28.1/timber_v0.28.1_darwin_arm64.tar.gz"
      sha256 "b44e68c48c31f6e3217fa007c9c9227680e320aaac18f6dad391d909435b4a0c"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.28.1/timber_v0.28.1_darwin_amd64.tar.gz"
      sha256 "ae4481d9dbc3b3c3d2c9ff4c9719ea9320e5c95b910693a0846f5738c9b1667c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/timber/releases/download/v0.28.1/timber_v0.28.1_linux_arm64.tar.gz"
      sha256 "ad96a771d59476f7602b58419704f33a7f03ad18d6c3fce00fa418dceee9cd67"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.28.1/timber_v0.28.1_linux_amd64.tar.gz"
      sha256 "600149231540de75bad24980b9e1f6049cbca8a6b73e2c2601281f4593e97604"
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
