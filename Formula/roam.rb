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
      url "https://github.com/nnutter/roam/releases/download/v2.1.9/roam_v2.1.9_darwin_arm64.tar.gz"
      sha256 "d39962c403a7ca415bb1faca876fda9b314c997219e67ad50b2c23fb45235f10"
    end

    on_intel do
      url "https://github.com/nnutter/roam/releases/download/v2.1.9/roam_v2.1.9_darwin_amd64.tar.gz"
      sha256 "7ce3d8dd724182f848259912a63e742b75909b3cabf6a6cd386f9abeab58250c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/roam/releases/download/v2.1.9/roam_v2.1.9_linux_arm64.tar.gz"
      sha256 "a033fc7d9fb0a43f99be71516348b7a8d2a388fccef5130ec3968623507b5371"
    end

    on_intel do
      url "https://github.com/nnutter/roam/releases/download/v2.1.9/roam_v2.1.9_linux_amd64.tar.gz"
      sha256 "a20f778a6ee49ec3f17feca17f32329db5ba924cf76de17dd3cf367447b5c06f"
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
