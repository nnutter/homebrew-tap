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
      url "https://github.com/nnutter/timber/releases/download/v0.25.2/timber_v0.25.2_darwin_arm64.tar.gz"
      sha256 "0fbbed59fa43284d13fa61c9d198cce16dbdf67904c705c68d8c3daa336c05a5"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.25.2/timber_v0.25.2_darwin_amd64.tar.gz"
      sha256 "8a9b4fac252bc0a3c6cfa3d32290b022c8b0767d48cf3a235cfc77b01bca06f6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/timber/releases/download/v0.25.2/timber_v0.25.2_linux_arm64.tar.gz"
      sha256 "c7f2b3a6ce51362c69096640afc09bf04af5f442a69d9dfddf0e15223918bc29"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.25.2/timber_v0.25.2_linux_amd64.tar.gz"
      sha256 "f26f2f4c4f909f81604e27d5d2748c8c705bb97b510253335c6e3dd332e96e85"
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
