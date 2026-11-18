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
      url "https://github.com/nnutter/roam/releases/download/v2.1.7/roam_v2.1.7_darwin_arm64.tar.gz"
      sha256 "ef9396f9f7ca5453a2aec2b4f0430ff1515af06ce10ce56239478329a10c63ff"
    end

    on_intel do
      url "https://github.com/nnutter/roam/releases/download/v2.1.7/roam_v2.1.7_darwin_amd64.tar.gz"
      sha256 "be75d7c518767b64bf23e1a56213c745d015dfe1333f8734562c403354665127"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/roam/releases/download/v2.1.7/roam_v2.1.7_linux_arm64.tar.gz"
      sha256 "5a1d204167fede3d07d59cbf93ba9006d14db36e23564e473cf58e21980ad105"
    end

    on_intel do
      url "https://github.com/nnutter/roam/releases/download/v2.1.7/roam_v2.1.7_linux_amd64.tar.gz"
      sha256 "e0a4e1997768bb92de8fe285e7feecda7c87ace764326598932b900245d4bc4e"
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
