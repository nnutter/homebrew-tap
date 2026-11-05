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
      url "https://github.com/nnutter/roam/releases/download/v2.1.4/roam_v2.1.4_darwin_arm64.tar.gz"
      sha256 "ef19a7369880a0c6af2488acd98f60520a2e2a902a3a7a1f23f72d62ee7d841d"
    end

    on_intel do
      url "https://github.com/nnutter/roam/releases/download/v2.1.4/roam_v2.1.4_darwin_amd64.tar.gz"
      sha256 "3480b833c44913ff2a1ca5ad1a9b45b294b1f59a13893c4075874a88413f4af4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/roam/releases/download/v2.1.4/roam_v2.1.4_linux_arm64.tar.gz"
      sha256 "cd11f343953985546ad49c76be448ddfbeebec42a1a6b5679ca4ece2ffdf68dd"
    end

    on_intel do
      url "https://github.com/nnutter/roam/releases/download/v2.1.4/roam_v2.1.4_linux_amd64.tar.gz"
      sha256 "3b142db3a64e28161a1c5d77c13f8b5e1aa764724125bc4c707c6b0f70e972fb"
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
