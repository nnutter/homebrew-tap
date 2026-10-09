class Slush < Formula
  desc "SSH/ET/mosh wrapper that starts Lemonade and reverse-tunnels its port"
  homepage "https://github.com/nnutter/slush"
  url "https://api.github.com/repos/nnutter/slush/tarball/v0.3.0",
      user: "x-access-token:#{ENV.fetch("HOMEBREW_GITHUB_API_TOKEN")}"
  sha256 "36743d02c6f259bec19440b14de5c48a45ef4d485f07f30cd0ade25979ef2675"
  head "ssh://git@github.com/nnutter/slush.git", branch: "main"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  def caveats
    <<~EOS
      slush requires lemonade on PATH at runtime:
        https://github.com/lemonade-command/lemonade
    EOS
  end

  test do
    assert_match "lemonade not found on PATH", shell_output("#{bin}/slush 2>&1", 1)
  end
end
