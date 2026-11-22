class Mdlint < Formula
  desc "Opinionated Markdown formatter and linter"
  homepage "https://github.com/nnutter/mdlint"
  url "https://github.com/nnutter/mdlint/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "e81514c66dbdc046d63fdfebac3c2401ba0151576e90df528cec6de65dd538f8"
  license "Unlicense"
  head "https://github.com/nnutter/mdlint.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    # The build script derives the version from Git unless this is set, and a
    # release tarball has no repository.
    ENV["MDLINT_RELEASE_TAG"] = "v#{version}"
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.md").write("* example\n")
    system bin/"mdlint", "format", "example.md"
    assert_equal "- example\n", (testpath/"example.md").read
    system bin/"mdlint", "format", "--check", "example.md"
  end
end
