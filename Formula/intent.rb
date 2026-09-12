class Intent < Formula
  desc "Refactor extractor"
  homepage "https://github.com/nnutter/intent"
  url "https://github.com/nnutter/intent/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "6c178c877cb73ebec89e4e3457f065a8cb6203e2ae6f8c2a796da7b4c37e936c"
  license "MIT"
  head "https://github.com/nnutter/intent.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[-X main.version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"intent")
    generate_completions_from_executable(bin/"intent", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/intent --version")
    assert_match "#compdef intent", (zsh_completion/"_intent").read
    assert_match "bash completion V2 for intent", (bash_completion/"intent").read
    assert_match "fish completion for intent", (fish_completion/"intent.fish").read
    assert_match "powershell completion for intent", (pwsh_completion/"_intent.ps1").read
  end
end
