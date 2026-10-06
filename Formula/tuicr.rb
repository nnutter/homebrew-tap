class Tuicr < Formula
  desc "Terminal UI for Code Reviews - review AI-generated diffs like a GitHub PR"
  homepage "https://github.com/nnutter/tuicr"
  head "https://github.com/nnutter/tuicr.git", branch: "main"
  license "MIT"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "tuicr", shell_output("#{bin}/tuicr --help")
  end
end
