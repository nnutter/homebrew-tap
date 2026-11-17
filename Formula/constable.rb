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
      url "https://github.com/nnutter/constable/releases/download/v0.9.2/constable_v0.9.2_darwin_arm64.tar.gz"
      sha256 "2157234e654d9504d0da577b1564a045e38de01d55919d691a6e74e520d03db7"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.9.2/constable_v0.9.2_darwin_amd64.tar.gz"
      sha256 "6a8adaf71be707139ce975fbb7bb88e8bb72e94d12bda2a5d18411463705b332"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/constable/releases/download/v0.9.2/constable_v0.9.2_linux_arm64.tar.gz"
      sha256 "b0b45ff60f78f1c9d70958a99c572dad2bc7896d88c8110d43b0ed3307da289d"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.9.2/constable_v0.9.2_linux_amd64.tar.gz"
      sha256 "f55f9643c099f8f08eca42a494242ff137896e43d795c387d0f159bae0989339"
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
