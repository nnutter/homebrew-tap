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
      url "https://github.com/nnutter/timber/releases/download/v0.24.0/timber_v0.24.0_darwin_arm64.tar.gz"
      sha256 "e53d47073ac67025eefd6441de6d819354f34e18a1e73c58789db8cf1f0177b3"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.24.0/timber_v0.24.0_darwin_amd64.tar.gz"
      sha256 "c71e19274b8188e1f619e99be9e13e92d2b1bf82c384132d14026d9f6bb0bf0f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/timber/releases/download/v0.24.0/timber_v0.24.0_linux_arm64.tar.gz"
      sha256 "d986c44bffa9ac599444f664ebd059f4c64b6b7d260022ea64061af462e1b079"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.24.0/timber_v0.24.0_linux_amd64.tar.gz"
      sha256 "72462e0d51336303bb7d8977e6b4f5a2bee81a7e5f4d2847b4d324bdb3cce2b7"
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
