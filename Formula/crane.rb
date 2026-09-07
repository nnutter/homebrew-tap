class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "a52cc7d61f8b2f043b7f0be1febecead5fceb791543c4790d699440f12d6b370"
  license "Apache-2.0"
  head "https://github.com/google/go-containerregistry.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}]

    system "go", "build", *std_go_args(ldflags:, output: bin/"crane"), "./cmd/crane"
    system "go", "build", *std_go_args(ldflags:, output: bin/"gcrane"), "./cmd/gcrane"
    # krane is a separate Go module, so it must be built from within
    # its own directory.
    cd "cmd/krane" do
      system "go", "build", *std_go_args(ldflags:, output: bin/"krane"), "."
    end

    generate_completions_from_executable(bin/"crane", shell_parameter_format: :cobra)
    generate_completions_from_executable(bin/"gcrane", shell_parameter_format: :cobra)
    generate_completions_from_executable(bin/"krane", shell_parameter_format: :cobra)
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2

    assert_match "gcrane", shell_output("#{bin}/gcrane --help")
    assert_match "krane", shell_output("#{bin}/krane --help")
  end
end
