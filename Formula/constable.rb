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
      url "https://github.com/nnutter/constable/releases/download/v0.10.2/constable_v0.10.2_darwin_arm64.tar.gz"
      sha256 "f9b20ac4e5b2c98433f93d6287b02110688b078c102e92951fa350287f2e7ce2"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.10.2/constable_v0.10.2_darwin_amd64.tar.gz"
      sha256 "1a9d6f943ab0ea9dd773ada744c4e393342c10d50632e0be03ed9bcfb71eca9b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/constable/releases/download/v0.10.2/constable_v0.10.2_linux_arm64.tar.gz"
      sha256 "ebe687ddfa281a4f9753af134feb57d9152b559de15228e60dede3f9db43c5b2"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.10.2/constable_v0.10.2_linux_amd64.tar.gz"
      sha256 "fe494130ae68dc6e863875a78f90045e1919ba99c771c8ff46dd7508cc629794"
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
