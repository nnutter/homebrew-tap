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
      url "https://github.com/nnutter/constable/releases/download/v0.7.0/constable_v0.7.0_darwin_arm64.tar.gz"
      sha256 "26fb20120c7a7f324a553b1ce452045261f4559f410836367e8fa8e3c6719938"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.7.0/constable_v0.7.0_darwin_amd64.tar.gz"
      sha256 "e62c1286e92155bb65dfcc38afcfe375df22dca12030688ecb7d832c2282d0e3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/constable/releases/download/v0.7.0/constable_v0.7.0_linux_arm64.tar.gz"
      sha256 "98fe53f95d16f28f35dfbcd84301b9d385f2fdeb289aa0d4cc9b57274d433a09"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.7.0/constable_v0.7.0_linux_amd64.tar.gz"
      sha256 "5941711749639b2a61d3dd67894e25f2c9bac65249cc0f3b96c777ecc7a4ca86"
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
