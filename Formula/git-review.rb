class GitReview < Formula
  desc "Review commits locally"
  homepage "https://github.com/nnutter/git-review"
  url "https://github.com/nnutter/git-review/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "0c452ec73f5a5bd378de917bf67e51dc0969a13e676423570f3d87dd0b54cf8f"
  license "MIT"
  head "https://github.com/nnutter/git-review.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X main.version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"git-review", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-review --version")

    assert_match "#compdef git-review", (zsh_completion/"_git-review").read
    assert_match "bash completion V2 for git-review", (bash_completion/"git-review").read
    assert_match "fish completion for git-review", (fish_completion/"git-review.fish").read
    assert_match "powershell completion for git-review", (pwsh_completion/"_git-review.ps1").read
  end
end
