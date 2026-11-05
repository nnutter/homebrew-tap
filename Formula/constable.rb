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
      url "https://github.com/nnutter/constable/releases/download/v0.8.0/constable_v0.8.0_darwin_arm64.tar.gz"
      sha256 "e2208cfc5bddedbb3256c8e7f1a379fb747377c046f38de41af2e9570e127e95"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.8.0/constable_v0.8.0_darwin_amd64.tar.gz"
      sha256 "fe92afa3b94f22de6c5528ad9a26a924cc4fd33635459e27f5e2626797c0bc77"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/constable/releases/download/v0.8.0/constable_v0.8.0_linux_arm64.tar.gz"
      sha256 "625e2b7aa8841f9f54b29f81b8156a0fbb91e6a9d88e93a12e9c0a53a1362e2d"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.8.0/constable_v0.8.0_linux_amd64.tar.gz"
      sha256 "2fbe8ebf47020a6c4bac393fafc0d5cc43cd823746de2fc1361e856c963d5e43"
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
