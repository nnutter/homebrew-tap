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
      url "https://github.com/nnutter/timber/releases/download/v0.27.0/timber_v0.27.0_darwin_arm64.tar.gz"
      sha256 "7946dda27d3ed969f31527441e75a899a7386217a4ed02453be17a50eb731e3c"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.27.0/timber_v0.27.0_darwin_amd64.tar.gz"
      sha256 "ae697aa6dff262b15da309de37cbe817716669f25bdb0d19647cbb90b335553a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/timber/releases/download/v0.27.0/timber_v0.27.0_linux_arm64.tar.gz"
      sha256 "44dd72485b85a9a533cc722c66bff2729e7549b9d242288e607a7377adfeafc0"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.27.0/timber_v0.27.0_linux_amd64.tar.gz"
      sha256 "fd79c6fa7978498e3ff1d9bd07ab498ce2ccdd378509ce8b3c1012d25f24ea3c"
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
