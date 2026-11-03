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
      url "https://github.com/nnutter/roam/releases/download/v2.1.2/roam_v2.1.2_darwin_arm64.tar.gz"
      sha256 "ff8dcba097e7fb3d4c6ea5970f17fa0dc27b4056389717c18b599e40624678ae"
    end

    on_intel do
      url "https://github.com/nnutter/roam/releases/download/v2.1.2/roam_v2.1.2_darwin_amd64.tar.gz"
      sha256 "d49659b984291d20e9b25aba9c5b1d21169a1957bcc60e2841884cf7fe2ed06b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/roam/releases/download/v2.1.2/roam_v2.1.2_linux_arm64.tar.gz"
      sha256 "0eeb98e33ffa96f98ac366e52ec71bd8447dfaf107850f775cb6f5310e6ef174"
    end

    on_intel do
      url "https://github.com/nnutter/roam/releases/download/v2.1.2/roam_v2.1.2_linux_amd64.tar.gz"
      sha256 "84d41b96d5e31be4bb3d05cb0e741a20b3f634f89ff5a31ed0cc532f95eeaa13"
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
