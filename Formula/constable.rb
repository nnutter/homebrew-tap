class Constable < Formula
  desc "Personal static analysis tool for Go"
  homepage "https://github.com/nnutter/constable"
  url "https://github.com/nnutter/constable/archive/refs/tags/v0.3.tar.gz"
  sha256 "81fccb219ff3d1633dc13a0a96a5a7582770036e212022da8da9ef6e51b19d0e"
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
