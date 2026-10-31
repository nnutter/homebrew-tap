class Mdlint < Formula
  desc "Opinionated Markdown formatter and linter"
  homepage "https://github.com/nnutter/mdlint"
  url "https://github.com/nnutter/mdlint/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "01d20de17982a7bad5eb074a370ab31ad2543edb675774c92a5b67f2969bd985"
  license "Unlicense"
  head "https://github.com/nnutter/mdlint.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.md").write("* example\n")
    system bin/"mdlint", "format", "example.md"
    assert_equal "- example\n", (testpath/"example.md").read
    system bin/"mdlint", "format", "--check", "example.md"
  end
end
