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
      url "https://github.com/nnutter/constable/releases/download/v0.9.5/constable_v0.9.5_darwin_arm64.tar.gz"
      sha256 "0ad670bc74fb365677a39470eb1bacd8587849d9704a5796a72375db95c90dca"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.9.5/constable_v0.9.5_darwin_amd64.tar.gz"
      sha256 "858a1e95c6ad782425a797bb511a1322ca60ddeee266e492270eedc2afe351a4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/constable/releases/download/v0.9.5/constable_v0.9.5_linux_arm64.tar.gz"
      sha256 "41d7f41c35f2f2dd45666c8d7cda986ddccb9aa84ed36b836a4975df66755000"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.9.5/constable_v0.9.5_linux_amd64.tar.gz"
      sha256 "c67522bfa29e0dd5a791c340699719deb2515153b2e4f7b93f7c8fd469cb81a1"
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
