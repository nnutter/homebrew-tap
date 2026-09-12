class GitBump < Formula
  desc "Bump tags"
  homepage "https://github.com/nnutter/git-bump"
  url "https://github.com/nnutter/git-bump/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b1cf551fedbdfc3613d13b6930a77d549c3e4c32d8569ee263c55ae2fd2f5d2c"
  license "MIT"
  head "https://github.com/nnutter/git-bump.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X main.version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
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
