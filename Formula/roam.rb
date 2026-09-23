class Roam < Formula
  desc "Manage dotfiles with a Git repository"
  homepage "https://github.com/nnutter/roam"
  url "https://github.com/nnutter/roam/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "36ec3683be1da3debfa97ddecc83ba1666d7d56712ba720174b9ba0b4dfe9dec"
  license "MIT"
  head "https://github.com/nnutter/roam.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X main.version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"roam", shell_parameter_format: :cobra, shells: [:zsh])
  end

  test do
    assert_match "Use roam like git", shell_output("#{bin}/roam --help")
    assert_match "Initialize the dotfiles repository", shell_output("#{bin}/roam setup -h")

    assert_match "#compdef roam", (zsh_completion/"_roam").read
    assert_match "_git", (zsh_completion/"_roam").read
  end
end
