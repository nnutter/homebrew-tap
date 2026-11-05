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
      url "https://github.com/nnutter/roam/releases/download/v2.1.5/roam_v2.1.5_darwin_arm64.tar.gz"
      sha256 "21eb4ccdda42533ce9cba12b4c30670be8d1468899acfd9ecedb5b5d441cf23d"
    end

    on_intel do
      url "https://github.com/nnutter/roam/releases/download/v2.1.5/roam_v2.1.5_darwin_amd64.tar.gz"
      sha256 "2a0be3505bb7698bb8d2066e7c3b293ac4192937d8cb8412a91f53a8af6f65e8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/roam/releases/download/v2.1.5/roam_v2.1.5_linux_arm64.tar.gz"
      sha256 "00332fec434935aec8853e76f376f1b7078f3be566f204931b5c8024f9297b54"
    end

    on_intel do
      url "https://github.com/nnutter/roam/releases/download/v2.1.5/roam_v2.1.5_linux_amd64.tar.gz"
      sha256 "88878c2518f226f76d3cd5ac26b94f42662c5c8a57350a5d26c26e1b4ffa60b3"
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
