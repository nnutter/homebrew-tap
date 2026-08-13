class GcloudTunnel < Formula
  desc "Publish local ports to a Cloud Workstation"
  homepage "https://github.com/nnutter/gcloud-tunnel"
  url "https://github.com/nnutter/gcloud-tunnel/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "90e8c629dc23f934d457913d45d694dbe201304ffac5d6c499c71c049efddcf5"
  license "MIT"
  head "https://github.com/nnutter/gcloud-tunnel.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gcloud-tunnel --version")
    assert_match "Publish local ports to a Cloud Workstation", shell_output("#{bin}/gcloud-tunnel --help")
  end
end
