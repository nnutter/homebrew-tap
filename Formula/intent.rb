class Intent < Formula
  desc "Refactor extractor"
  homepage "https://github.com/nnutter/intent"
  url "https://github.com/nnutter/intent/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "6dccbe5d73efd2d465b18db9ca47537b85abb8e6f225c0a9ec53452762fd85e1"
  license "MIT"
  head "https://github.com/nnutter/intent.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[-X main.version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"intent")
  end

  test do
    # assert_match version.to_s, shell_output("#{bin}/intent --version")
    assert_match "intent version", shell_output("#{bin}/intent --version")
  end
end
