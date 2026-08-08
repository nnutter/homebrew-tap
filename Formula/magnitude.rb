class Magnitude < Formula
  desc "Open source agent built on local models, 100% private and offline"
  homepage "https://github.com/magnitudedev/magnitude"
  url "https://registry.npmjs.org/@magnitudedev/cli/-/cli-0.0.1-alpha.37.tgz"
  sha256 "9531fcc78e083bac401030aa6dadbbcb04d38e096db5a9717420a9e009955c66"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/magnitude --version")
  end
end
