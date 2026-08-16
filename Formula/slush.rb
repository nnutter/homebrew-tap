class Slush < Formula
  desc "SSH/ET/mosh wrapper that starts Lemonade and reverse-tunnels its port"
  homepage "https://github.com/nnutter/slush"
  url "https://github.com/nnutter/slush/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "879db781e94df42facb5ff9ce1535ef4c7cd43ba4209ebe7c9bea4c0b018df88"
  head "https://github.com/nnutter/slush.git", branch: "main"

  livecheck do
    url :stable
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
