class BraveSearchCli < Formula
  desc "Token-efficient CLI for the Brave Search API"
  homepage "https://github.com/brave/brave-search-cli"
  url "https://github.com/brave/brave-search-cli/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "1bbd05caa55d0db772ac13a50cb21a261e3522654e3a1199858821c665cc637e"
  license "MPL-2.0"
  head "https://github.com/brave/brave-search-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bx --version")
    assert_match "COMMAND", shell_output("#{bin}/bx --help")
  end
end
