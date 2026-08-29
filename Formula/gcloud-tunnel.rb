class GcloudTunnel < Formula
  desc "Publish local ports to a Cloud Workstation"
  homepage "https://github.com/nnutter/gcloud-tunnel"
  # GitHub App tokens cannot fetch github.com /archive/ URLs.
  url "https://api.github.com/repos/nnutter/gcloud-tunnel/tarball/v0.2.3", # rubocop:disable FormulaAudit/Urls
      user: "x-access-token:#{ENV.fetch("HOMEBREW_GITHUB_API_TOKEN")}"
  sha256 "27894d2ca74ccd5bff41d880112c4f361580c54ac883b128d8e468cdf90bbddc"
  license "MIT"
  head "https://github.com/nnutter/gcloud-tunnel.git", branch: "master"

  livecheck do
    url :homepage
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
