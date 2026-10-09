class Slush < Formula
  desc "Tunnel clipboard and open calls through SSH/Mosh shell"
  homepage "https://github.com/nnutter/slush"
  url "https://api.github.com/repos/nnutter/slush/tarball/v0.3.0",
      user: "x-access-token:#{ENV.fetch("HOMEBREW_GITHUB_API_TOKEN")}"
  sha256 "36743d02c6f259bec19440b14de5c48a45ef4d485f07f30cd0ade25979ef2675"
  head "ssh://git@github.com/nnutter/slush.git", branch: "main"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X main.version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"slush"), "."
    generate_completions_from_executable(bin/"slush", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slush --version")

    assert_match "#compdef slush", (zsh_completion/"_slush").read
    assert_match "bash completion V2 for slush", (bash_completion/"slush").read
    assert_match "fish completion for slush", (fish_completion/"slush.fish").read
    assert_match "powershell completion for slush", (pwsh_completion/"_slush.ps1").read
  end
end
