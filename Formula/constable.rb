class Constable < Formula
  desc "Personal static analysis tool for Go"
  homepage "https://github.com/nnutter/constable"
  url "https://github.com/nnutter/constable/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "ea0996c2acbef365496bdb6a44ff44c6790929808243c7f02475e38903886457"
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
