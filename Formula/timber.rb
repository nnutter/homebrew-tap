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
      url "https://github.com/nnutter/timber/releases/download/v0.25.3/timber_v0.25.3_darwin_arm64.tar.gz"
      sha256 "bcfff2a777b672c101bc38e89680d9d6730346a3093385b71f4dd99726a45d43"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.25.3/timber_v0.25.3_darwin_amd64.tar.gz"
      sha256 "3f2a2ee18dfc23780c3cc4b39536e95b5b8300341e2479754d7232d0b8d63c4c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/timber/releases/download/v0.25.3/timber_v0.25.3_linux_arm64.tar.gz"
      sha256 "e5769e0c9dfc42123974c5b598ed79b4fe8e06004579c7fdcedbf366eb0ed8ca"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.25.3/timber_v0.25.3_linux_amd64.tar.gz"
      sha256 "363445eaddc736cb619f97288b117cc402ceae222aebfa620070340068c64ea1"
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
