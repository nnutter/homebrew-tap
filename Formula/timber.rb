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
      url "https://github.com/nnutter/timber/releases/download/v0.26.2/timber_v0.26.2_darwin_arm64.tar.gz"
      sha256 "5bc528cdf6bcdcbca7011467e160733b887a4b2e249b5aded62c68da69a6af24"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.26.2/timber_v0.26.2_darwin_amd64.tar.gz"
      sha256 "c848ef991e55b00fac2fadd92b617d497f02166c9460f58fd07fbd9efccd754f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/timber/releases/download/v0.26.2/timber_v0.26.2_linux_arm64.tar.gz"
      sha256 "f6a128f3b8400ce1e12ddb843f34510eb99c3aa475a58b1780b914ead59f602e"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.26.2/timber_v0.26.2_linux_amd64.tar.gz"
      sha256 "8b503c0b29421a857864dd1b2357fff68e81525c220130f38c1522525beb8040"
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
