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
      url "https://github.com/nnutter/constable/releases/download/v0.9.1/constable_v0.9.1_darwin_arm64.tar.gz"
      sha256 "2e4794282400dc8d8b04de3ae17507baa95886ba764ef3002ad38fc11e519585"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.9.1/constable_v0.9.1_darwin_amd64.tar.gz"
      sha256 "6cbf259712964382f337dce27c3c0c25a65c0d46bbc3009c70d716dbd33c1c67"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/constable/releases/download/v0.9.1/constable_v0.9.1_linux_arm64.tar.gz"
      sha256 "94c45ce1c0f6444b9140e591f1fb3cb450120ede655f6f7c5f76e744e983edc3"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.9.1/constable_v0.9.1_linux_amd64.tar.gz"
      sha256 "c3aa624dcda47f7b4dfca6198d55f70706e3160a6e9aa50c971f712d5a5adc4b"
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
