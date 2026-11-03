class GitBump < Formula
  desc "Bump tags"
  homepage "https://github.com/nnutter/git-bump"
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  head do
    url "https://github.com/nnutter/git-bump.git", branch: "master"
    depends_on "go" => :build
  end

  on_macos do
    on_arm do
      url "https://github.com/nnutter/git-bump/releases/download/v0.3.3/git-bump_v0.3.3_darwin_arm64.tar.gz"
      sha256 "1e4b3ae76c276f0ddb3cace5c0e1c6187ace9e195f2a5ccae295c14266811016"
    end

    on_intel do
      url "https://github.com/nnutter/git-bump/releases/download/v0.3.3/git-bump_v0.3.3_darwin_amd64.tar.gz"
      sha256 "fcb5dde9b8a32347cac6a80497af9211a06eef5a99c6567e7c72898f55085b27"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/git-bump/releases/download/v0.3.3/git-bump_v0.3.3_linux_arm64.tar.gz"
      sha256 "c1fe9efc317b4cd90faf2aaf018f6d20e3a7e13cebb2ab5141a1d82d75162b40"
    end

    on_intel do
      url "https://github.com/nnutter/git-bump/releases/download/v0.3.3/git-bump_v0.3.3_linux_amd64.tar.gz"
      sha256 "87b3170a14694652597cedfe52fbd0185beaf4161eb220e32401bc929ad288a5"
    end
  end

  def install
    if build.head?
      ldflags = %W[-X main.version=#{version}]
      system "go", "build", *std_go_args(ldflags:)
    else
      # The release archive names the binary after the archive itself.
      bin.install Dir["*"].first => "git-bump"
    end

    generate_completions_from_executable(bin/"git-bump", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-bump --version")
    assert_match "#compdef git-bump", (zsh_completion/"_git-bump").read
    assert_match "bash completion V2 for git-bump", (bash_completion/"git-bump").read
    assert_match "fish completion for git-bump", (fish_completion/"git-bump.fish").read
    assert_match "powershell completion for git-bump", (pwsh_completion/"_git-bump.ps1").read
  end
end
