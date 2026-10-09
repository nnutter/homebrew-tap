class Umpire < Formula
  desc "Review commits locally"
  homepage "https://github.com/nnutter/umpire"
  url "https://github.com/nnutter/umpire/archive/refs/tags/v0.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
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
    generate_completions_from_executable(bin/"umpire", shell_parameter_format: :cobra, shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/umpire --version")
    assert_match "#compdef umpire", (zsh_completion/"_umpire").read
    assert_match "_git", (zsh_completion/"_umpire").read
    assert_match "complete -F _git umpire", (bash_completion/"umpire").read
  end
end
