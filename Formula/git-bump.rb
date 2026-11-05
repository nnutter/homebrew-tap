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
      url "https://github.com/nnutter/git-bump/releases/download/v0.3.5/git-bump_v0.3.5_darwin_arm64.tar.gz"
      sha256 "d2d9937f9c8697a51a15154fe6ea48077bec09e01a34dc2bc57b7140a9737adf"
    end

    on_intel do
      url "https://github.com/nnutter/git-bump/releases/download/v0.3.5/git-bump_v0.3.5_darwin_amd64.tar.gz"
      sha256 "a78f889d541939c35ebbc811a027cfb52b497cad0394ab74e8f732983afc14d7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/git-bump/releases/download/v0.3.5/git-bump_v0.3.5_linux_arm64.tar.gz"
      sha256 "0d74ee7d472a30b1551a12d75e233611bd0ccedf6c3478e786510729d423b13e"
    end

    on_intel do
      url "https://github.com/nnutter/git-bump/releases/download/v0.3.5/git-bump_v0.3.5_linux_amd64.tar.gz"
      sha256 "af760bd40881ab7aa78f5b940c98053e31297070da4b0e850139d15276b7df45"
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
