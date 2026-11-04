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
      url "https://github.com/nnutter/timber/releases/download/v0.23.0/timber_v0.23.0_darwin_arm64.tar.gz"
      sha256 "73f4bcac328c6f6ad2a953a5749555f1b838d161505392958dc5261d03b7f1ff"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.23.0/timber_v0.23.0_darwin_amd64.tar.gz"
      sha256 "7b6db8647c4817e9a24848fd7e97d4a579ab07648e4779b49741a855cf00e1f4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/timber/releases/download/v0.23.0/timber_v0.23.0_linux_arm64.tar.gz"
      sha256 "aee70a679cdde0cd5f74f09dee4c80e2637e44008b06c4d297205954e244cbcf"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.23.0/timber_v0.23.0_linux_amd64.tar.gz"
      sha256 "16fe9dbf607d36cf7da3b1a48fa960e1d39cb3cecc8176d292c86d874dd5c02e"
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
