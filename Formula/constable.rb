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
      url "https://github.com/nnutter/constable/releases/download/v0.10.1/constable_v0.10.1_darwin_arm64.tar.gz"
      sha256 "39990012b1c17c7efa537070a497b8f759fb4440f9df40d223e360d776de392a"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.10.1/constable_v0.10.1_darwin_amd64.tar.gz"
      sha256 "9ea2593ee04b1a43354cad67b1425f1e78157507289fd386e52a97790236ec02"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/constable/releases/download/v0.10.1/constable_v0.10.1_linux_arm64.tar.gz"
      sha256 "c2891fd7c60dc425486673faf65e0942a9b65b2359c277eb75811758b031d531"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.10.1/constable_v0.10.1_linux_amd64.tar.gz"
      sha256 "375733dd02b1d7033f2cac3f586c93cf7291b42c5e0f8e4792ff33f2fe525464"
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
