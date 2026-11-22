class Roam < Formula
  desc "Manage dotfiles with a Git repository"
  homepage "https://github.com/nnutter/roam"
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  head do
    url "https://github.com/nnutter/roam.git", branch: "master"
    depends_on "go" => :build
  end

  on_macos do
    on_arm do
      url "https://github.com/nnutter/roam/releases/download/v2.1.8/roam_v2.1.8_darwin_arm64.tar.gz"
      sha256 "8a6604caacfd441272f3aeb4f0f1d9c7d20374cc324109d8939a43c2b4452886"
    end

    on_intel do
      url "https://github.com/nnutter/roam/releases/download/v2.1.8/roam_v2.1.8_darwin_amd64.tar.gz"
      sha256 "e5c3c9ee7520e564294ebe671ee513b58c19549b0e8b8b8c7dd4dd1fb16ceddd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/roam/releases/download/v2.1.8/roam_v2.1.8_linux_arm64.tar.gz"
      sha256 "f152d17a404d2d3ceb1a0f0d5d5fc25bd450741fbdcf06b135654496cbe83979"
    end

    on_intel do
      url "https://github.com/nnutter/roam/releases/download/v2.1.8/roam_v2.1.8_linux_amd64.tar.gz"
      sha256 "d185c9f8fe57f86d6ae8cddc4b898e970fe8d013affc8dbc26065bb80f14f73f"
    end
  end

  def install
    if build.head?
      ldflags = %W[-X main.version=#{version}]
      system "go", "build", *std_go_args(ldflags:)
    else
      # The release archive names the binary after the archive itself.
      bin.install Dir["*"].first => "roam"
    end

    generate_completions_from_executable(bin/"roam", shell_parameter_format: :cobra, shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/roam --version")
    assert_match "#compdef roam", (zsh_completion/"_roam").read
    assert_match "_git", (zsh_completion/"_roam").read
    assert_match "complete -F _git roam", (bash_completion/"roam").read
  end
end
