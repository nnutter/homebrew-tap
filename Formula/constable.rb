class Constable < Formula
  desc "Personal static analysis tool for Go"
  homepage "https://github.com/nnutter/constable"
  url "https://github.com/nnutter/constable/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "a41cb9392593ec30eb8ce4e7b0463a13c06850aa097deac5ccb7d9ea01870f98"
  license "MIT"
  head "https://github.com/nnutter/constable.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[-X main.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"constable"), "./cmd/constable"
  end

  test do
    assert_match "constable", shell_output("#{bin}/constable -V")
  end
end
