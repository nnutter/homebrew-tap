class Constable < Formula
  desc "Personal static analysis tool for Go"
  homepage "https://github.com/nnutter/constable"
  url "https://github.com/nnutter/constable/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "5d20e06f3719a1ef36a3cd1637bae79920b74c5f5b4cc104a6a251740c898a81"
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
