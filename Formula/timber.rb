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
      url "https://github.com/nnutter/timber/releases/download/v0.25.1/timber_v0.25.1_darwin_arm64.tar.gz"
      sha256 "b3e9cdf1440e646257373713370770c01348cb7bd3411238f56ded169ce69fd8"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.25.1/timber_v0.25.1_darwin_amd64.tar.gz"
      sha256 "e98a78f39d99a66cd64445a5e2544fb4da9c5486eaa23a98cfa657a6762530ed"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/timber/releases/download/v0.25.1/timber_v0.25.1_linux_arm64.tar.gz"
      sha256 "c357e1683e106c4f2c7ce430e837321ac2b0e25a82c12b07b6392dc8e309f6eb"
    end

    on_intel do
      url "https://github.com/nnutter/timber/releases/download/v0.25.1/timber_v0.25.1_linux_amd64.tar.gz"
      sha256 "d75a961c27b61cf2d377d1e49f9b39aca7d7b200324ac41f9ae244dc479f6fef"
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
