class Umpire < Formula
  desc "Review commits locally"
  homepage "https://github.com/nnutter/umpire"
  url "https://github.com/nnutter/umpire/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "785424decfaa1efc9a5f392a1a1f22dad57ce626f361188ed882fa1e0cc74176"
  license "MIT"
  head "https://github.com/nnutter/umpire.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X main.version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"umpire", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/umpire --version")

    assert_match "#compdef umpire", (zsh_completion/"_umpire").read
    assert_match "bash completion V2 for umpire", (bash_completion/"umpire").read
    assert_match "fish completion for umpire", (fish_completion/"umpire.fish").read
    assert_match "powershell completion for umpire", (pwsh_completion/"_umpire.ps1").read
  end
end
