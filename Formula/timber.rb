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
      url "https://github.com/nnutter/timber/releases/download/v0.25.4/timber_v0.25.4_darwin_arm64.tar.gz"
      sha256 "17841552f9c122711cd6ea8d9ec26cc9bad8f63df387fbd71b4bae0a58241c86"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.25.4/timber_v0.25.4_darwin_amd64.tar.gz"
      sha256 "5374b2e4a8b5afd34e70a77ef3ab9b6f7439cf7827b6a4d0503d677fa80eafb6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/timber/releases/download/v0.25.4/timber_v0.25.4_linux_arm64.tar.gz"
      sha256 "9a6d8c1adc71f2bd1b0911991968a6df9d4cf549b9ac1a52d57cd90e99adb952"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.25.4/timber_v0.25.4_linux_amd64.tar.gz"
      sha256 "bbb18d04ad4f0a36cb8811a3578c7f77240570a3b690c37e9531811932fd5aa0"
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
