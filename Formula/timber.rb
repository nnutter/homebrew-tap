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
      url "https://github.com/nnutter/timber/releases/download/v0.28.0/timber_v0.28.0_darwin_arm64.tar.gz"
      sha256 "48f7306f5783a8ed3eaf322a9cb1614f3f3886822ae711e0fd0d6b7efca3fa0c"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.28.0/timber_v0.28.0_darwin_amd64.tar.gz"
      sha256 "d05be880feb9c4802b9efa2ca9f4f408b29051d0f6ff0a8b5b8c8b58c47e2561"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/timber/releases/download/v0.28.0/timber_v0.28.0_linux_arm64.tar.gz"
      sha256 "89e16276b87166d80cd6a4f476169fe1316e5782b6018896af9a5611086d3793"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.28.0/timber_v0.28.0_linux_amd64.tar.gz"
      sha256 "dd51f5e99946439756ec3247127db6b7f92db4109467f84418094355a9e2f923"
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
