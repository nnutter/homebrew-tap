class Mdlint < Formula
  desc "Opinionated Markdown formatter and linter"
  homepage "https://github.com/nnutter/mdlint"
  url "https://github.com/nnutter/mdlint/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "44d6902bd2c3ceceae169b9baa13ebe117a3ad05480c3940bac86d90e768bc89"
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
