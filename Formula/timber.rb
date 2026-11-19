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
      url "https://github.com/nnutter/timber/releases/download/v0.26.0/timber_v0.26.0_darwin_arm64.tar.gz"
      sha256 "8da7c9d3a32a9a2e3cf482f81fd5c0f14b7c0f85359a7411275845d7f1a803d1"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.26.0/timber_v0.26.0_darwin_amd64.tar.gz"
      sha256 "b2e0b20f4a7436ff344c36b6c0176957198875d90216626c93ad38cfbf4cdbdd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/timber/releases/download/v0.26.0/timber_v0.26.0_linux_arm64.tar.gz"
      sha256 "3cc08f9888edea5ae97a90c13c4719e55e90cd38dd9020d5cf4a42b2a4fc0efb"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.26.0/timber_v0.26.0_linux_amd64.tar.gz"
      sha256 "f2fb066f1f0663dd1e165be0dce2d520323213d534a8578e35d3a9a4227ad1f7"
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
