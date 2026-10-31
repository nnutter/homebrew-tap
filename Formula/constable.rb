class Constable < Formula
  desc "Personal static analysis tool for Go"
  homepage "https://github.com/nnutter/constable"
  url "https://github.com/nnutter/constable/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "24aceafcf3a62ca9b76ade8898ba9c55e8c718431ea5e5ef0557ce85c0e59e62"
  license "MIT"
  head "https://github.com/nnutter/constable.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[-X main.version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"constable"), "./cmd/constable"
  end

  test do
    assert_match "constable", shell_output("#{bin}/constable -V")
  end
end
