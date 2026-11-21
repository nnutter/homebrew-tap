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
      url "https://github.com/nnutter/timber/releases/download/v0.26.1/timber_v0.26.1_darwin_arm64.tar.gz"
      sha256 "52687516403d2572c08ef43f73375568aea3b96f570443258a0d0f7a5b2ad306"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.26.1/timber_v0.26.1_darwin_amd64.tar.gz"
      sha256 "df5e397f5ae5c9a31ae60bdbb845a1be293760efc97d1f25ace1ac8cf9294057"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/timber/releases/download/v0.26.1/timber_v0.26.1_linux_arm64.tar.gz"
      sha256 "1cfc63c610a3253421e9223e57e1222a69a5b82322757da750de1994ff662b8a"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.26.1/timber_v0.26.1_linux_amd64.tar.gz"
      sha256 "65880784de1264ae29ae091e378d5bc5ad0a3bed593ae72e65b1c294df5a8e0d"
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
