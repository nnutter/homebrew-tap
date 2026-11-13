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
      url "https://github.com/nnutter/roam/releases/download/v2.1.6/roam_v2.1.6_darwin_arm64.tar.gz"
      sha256 "3b6aa2a9f82a18a2b26c8a0326222b0af8952913054c1745020dc5e9f93053de"
    end

    on_intel do
      url "https://github.com/nnutter/roam/releases/download/v2.1.6/roam_v2.1.6_darwin_amd64.tar.gz"
      sha256 "d33781dbe5d8621af8272f9a8e8b94a100a43949ac016b9200c92d7969bbfeeb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/roam/releases/download/v2.1.6/roam_v2.1.6_linux_arm64.tar.gz"
      sha256 "0d116f470dd74d27c852457abc31725979d274ed1353a5002ad99d12c2ca2f48"
    end

    on_intel do
      url "https://github.com/nnutter/roam/releases/download/v2.1.6/roam_v2.1.6_linux_amd64.tar.gz"
      sha256 "7c4d5b4abe1fa0a7fee2376e44107740567fe411e0c95f3752c0262aeb477a7d"
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
