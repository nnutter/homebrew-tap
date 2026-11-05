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
      url "https://github.com/nnutter/git-bump/releases/download/v0.3.6/git-bump_v0.3.6_darwin_arm64.tar.gz"
      sha256 "e6d6c3e64b97a63b3bd5363ffe4440830d6f7cb9be0b3f97210a33d515f8e417"
    end

    on_intel do
      url "https://github.com/nnutter/git-bump/releases/download/v0.3.6/git-bump_v0.3.6_darwin_amd64.tar.gz"
      sha256 "3823eaeb1f8cd1ae96bab6a35623b54345b5b23f721966e2ea0da91596e537e5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/git-bump/releases/download/v0.3.6/git-bump_v0.3.6_linux_arm64.tar.gz"
      sha256 "811cf2aaa8eb16c8ff325bd612e98e2dd39c368cdeb0e4930df5eaf58a8001ac"
    end

    on_intel do
      url "https://github.com/nnutter/git-bump/releases/download/v0.3.6/git-bump_v0.3.6_linux_amd64.tar.gz"
      sha256 "fbb6e9e4280cccfcb3a4afa6e9343e09fa8d4c2a64944bc575bf68b2d6c83bcb"
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
