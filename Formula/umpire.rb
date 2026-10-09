class Umpire < Formula
  desc "Review commits locally"
  homepage "https://github.com/nnutter/umpire"
  url "https://github.com/nnutter/umpire/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "14955bc59b3b3412c3ef62cabedebc698cdb62ccd2eec2a12fc70828ee4607fe"
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
