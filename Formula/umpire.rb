class Umpire < Formula
  desc "Review commits locally"
  homepage "https://github.com/nnutter/git-review"
  url "https://github.com/nnutter/umpire/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "9bd3f1ce97a02ad2d4d821ec9fd13e9b444a662ec6dfc310a484b41ebcfb73c6"
  license "MIT"

  disable! date: "2026-10-14", because: "has been renamed to git-review", replacement_formula: "git-review"
end
