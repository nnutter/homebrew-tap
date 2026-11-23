class Constable < Formula
  desc "Personal static analysis tool for Go"
  homepage "https://github.com/nnutter/constable"
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  head do
    url "https://github.com/nnutter/constable.git", branch: "master"
    depends_on "go" => :build
  end

  on_macos do
    on_arm do
      url "https://github.com/nnutter/constable/releases/download/v0.9.6/constable_v0.9.6_darwin_arm64.tar.gz"
      sha256 "5d92d5c55b12892996a1f4bfc4f8cd1cd1aa346760d4fda8b4ac416f9d3f8096"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.9.6/constable_v0.9.6_darwin_amd64.tar.gz"
      sha256 "2ab0dd3bb05a5142762952a8e1c7a72d7553d681eb8a9fd5da8a39be0bc9285c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/constable/releases/download/v0.9.6/constable_v0.9.6_linux_arm64.tar.gz"
      sha256 "3c0576cc47575cf7409eae42cffc2ae2eca10a364244e2bbf520e09570b50306"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.9.6/constable_v0.9.6_linux_amd64.tar.gz"
      sha256 "1d89b77f1925c5c42beadf1ae786403f1d4369b57acd3b5db637f900bb9fe685"
    end
  end

  def install
    if build.head?
      ldflags = %W[-X main.version=#{version}]
      system "go", "build", *std_go_args(ldflags:, output: bin/"constable"), "./cmd/constable"
    else
      # The release archive names the binary after the archive itself.
      bin.install Dir["*"].first => "constable"
    end
  end

  test do
    assert_match "constable", shell_output("#{bin}/constable -V")
  end
end
