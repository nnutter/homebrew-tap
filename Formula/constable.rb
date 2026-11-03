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
      url "https://github.com/nnutter/constable/releases/download/v0.5.1/constable_v0.5.1_darwin_arm64.tar.gz"
      sha256 "ca0ef1037972e3637886ca72f09ea8aa57f44bfe1af7461187016bc9e87e79b4"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.5.1/constable_v0.5.1_darwin_amd64.tar.gz"
      sha256 "fcdf2c4e7fdd319a49e0da8a8a7417ff616370e972b235c7ef2cd9f79f116daf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/constable/releases/download/v0.5.1/constable_v0.5.1_linux_arm64.tar.gz"
      sha256 "f21b0d1f7001b1064bf041e7b9c8762a49573bc2bd7924342640568544d92cd7"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.5.1/constable_v0.5.1_linux_amd64.tar.gz"
      sha256 "4cecfcf2a123b27096e0394484413d824071d84acf97311a73c21f33ce53d3a3"
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
