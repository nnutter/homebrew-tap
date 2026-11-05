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
      url "https://github.com/nnutter/timber/releases/download/v0.24.1/timber_v0.24.1_darwin_arm64.tar.gz"
      sha256 "b9e8c7f8954c399e7fe8f295740cade9f88373afda4c2d3e4bc3f637b63dba65"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.24.1/timber_v0.24.1_darwin_amd64.tar.gz"
      sha256 "64ae659e8bd7a7f4ba4b3661bad8af6e39befa866c4331cc59b130f265bfe968"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/timber/releases/download/v0.24.1/timber_v0.24.1_linux_arm64.tar.gz"
      sha256 "27fe26cb9107b2e0724658d26476869b1755b803d1929c934c5f342dcf35617c"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.24.1/timber_v0.24.1_linux_amd64.tar.gz"
      sha256 "7de8f7a4860b48fb74eacf1667426143d5b449637cc59a4d5ea6150cb246c784"
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
