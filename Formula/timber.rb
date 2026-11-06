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
      url "https://github.com/nnutter/timber/releases/download/v0.24.3/timber_v0.24.3_darwin_arm64.tar.gz"
      sha256 "a312c466c2f7f575562691700d397e38b67fa812b623015f7003e3d8253db7d0"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.24.3/timber_v0.24.3_darwin_amd64.tar.gz"
      sha256 "5e68cebe737c5c33470cb050590c799b5fc3361855d0762061c14c52f190ce5c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/timber/releases/download/v0.24.3/timber_v0.24.3_linux_arm64.tar.gz"
      sha256 "9a08a1dbf841ceecb42ab4e747249ee05a4c85294d1bb0c2a0dfd49c9404a6d3"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.24.3/timber_v0.24.3_linux_amd64.tar.gz"
      sha256 "f08564409201cb14f61d3f56ef637b36fc60846766c7d0946c88a4fc6082f4b0"
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
