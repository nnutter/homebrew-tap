class Httpyat < Formula
  desc "A httpYac TUI"
  homepage "https://github.com/nnutter/httpyat"
  url "https://github.com/nnutter/httpYat/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "7b93794d134b08d5cc8897b0f5e9ef5d40de2983a3e88c868da522e60cc2f422"
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
