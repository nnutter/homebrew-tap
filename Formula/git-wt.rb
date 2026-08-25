class GitWt < Formula
  desc "Manage Git worktrees using a consistent naming convention"
  homepage "https://github.com/nnutter/timber"
  url "https://github.com/nnutter/timber/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "edad5df7c5a53cbf21e3eb9dcba22cec982367dfd44cc40ffae1003e50bfa1fc"
  license "MIT"

  disable! date: "2026-08-25", because: "has been renamed to timber", replacement_formula: "timber"
end
