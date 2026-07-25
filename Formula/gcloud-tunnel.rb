class GcloudTunnel < Formula
  desc "Publish local ports to a Cloud Workstation"
  homepage "https://github.com/nnutter/gcloud-tunnel"
  url "https://github.com/nnutter/gcloud-tunnel/archive/refs/tags/v0.1.tar.gz"
  sha256 "90b0d39699ac25567e898279050a35fd420795fd49a1051d79fcccff905b9e5f"
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
