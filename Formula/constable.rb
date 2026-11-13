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
      url "https://github.com/nnutter/constable/releases/download/v0.9.0/constable_v0.9.0_darwin_arm64.tar.gz"
      sha256 "c1463785080bfd854f050dcc129d8a1e1c659893b3e411f3267e66e705d19ca9"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.9.0/constable_v0.9.0_darwin_amd64.tar.gz"
      sha256 "d1373ca4367bc38e16713d0d2157d9e8e6f2dbf1a600da607e25be27fec255b1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/constable/releases/download/v0.9.0/constable_v0.9.0_linux_arm64.tar.gz"
      sha256 "996dda63c13491738db1fcd9a0a262adbb6ae91e41db65401ba1553221eb35e6"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.9.0/constable_v0.9.0_linux_amd64.tar.gz"
      sha256 "bed79de4a01b65c1c5560f01aa96500c23f7197a46513534049b8623e5367868"
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
