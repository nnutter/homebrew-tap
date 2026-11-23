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
      url "https://github.com/nnutter/timber/releases/download/v0.26.3/timber_v0.26.3_darwin_arm64.tar.gz"
      sha256 "f3ad46d8c838b0f705387501d0ccbe8050b584a56d700ca197bab6a0c72a71a7"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.26.3/timber_v0.26.3_darwin_amd64.tar.gz"
      sha256 "7b76b094bbb0bd4d6e6d3e0c382d94c1d8cd258220c68de1c83b1cf043a4f83b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/timber/releases/download/v0.26.3/timber_v0.26.3_linux_arm64.tar.gz"
      sha256 "28f14e4a9b9a411deacfe934b34d2373f6d57736d0d9a4b1113afbc479229dff"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.26.3/timber_v0.26.3_linux_amd64.tar.gz"
      sha256 "9856c1c076b1a96d2319214bc2d5b2e1f03853b8a6df14486924bfac529e93bf"
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
