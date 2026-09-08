class Intent < Formula
  desc "Refactor extractor"
  homepage "https://github.com/nnutter/intent"
  url "https://github.com/nnutter/intent/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "945bcb8000d7b9e2c5d8cea1d43e45c5ce4504fa49f924156daecb97992ce670"
  license "MIT"
  head "https://github.com/nnutter/intent.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/nnutter/intent/internal/cli.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"intent")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/intent --version")
  end
end
