class Httpyat < Formula
  desc "A httpYac TUI"
  homepage "https://github.com/nnutter/httpyat"
  url "https://github.com/nnutter/httpYat/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "1afeb7e5125378963c5cf9c3d99685622d96efec6cc38dac58efab500c04e788"
  license "MIT"
  head "https://github.com/nnutter/httpyat.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[-X main.version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"httpyat"), "./cmd/httpyat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/httpyat -version")
  end
end
