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
      url "https://github.com/nnutter/timber/releases/download/v0.24.2/timber_v0.24.2_darwin_arm64.tar.gz"
      sha256 "5b2a215156add7459946b215d3cdf88b7fe0470a7a20f9ee1bfa76294a1afcd6"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.24.2/timber_v0.24.2_darwin_amd64.tar.gz"
      sha256 "5cae2956ded9ee70b26bdf8928c7fe41b33324881557c644d298198c638d2838"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/timber/releases/download/v0.24.2/timber_v0.24.2_linux_arm64.tar.gz"
      sha256 "77ce4a4815706ea214c822b842d569dd3a9dbcd5e5fa7dd30203cf73ff98515d"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.24.2/timber_v0.24.2_linux_amd64.tar.gz"
      sha256 "d804302a18d5ddb50460acdd7579dfdda09ee6ea91889b39431e6f70b2c2a2c1"
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
