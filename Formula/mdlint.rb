class Mdlint < Formula
  desc "Opinionated Markdown formatter and linter"
  homepage "https://github.com/nnutter/mdlint"
  url "https://github.com/nnutter/mdlint/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "65fa437344dbb685220953d887a4099660a62611001970d6e9057bd6f1a90a39"
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
