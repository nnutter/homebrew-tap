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
      url "https://github.com/nnutter/constable/releases/download/v0.9.3/constable_v0.9.3_darwin_arm64.tar.gz"
      sha256 "0d49f2f3d9b234687c8d021820c48b3f0ca424f821c47e7391999cd1fd9ccb93"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.9.3/constable_v0.9.3_darwin_amd64.tar.gz"
      sha256 "2499a402f2ab15f60cef347798271d7ed68a120385861e91dd3e349359d7c72d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nnutter/constable/releases/download/v0.9.3/constable_v0.9.3_linux_arm64.tar.gz"
      sha256 "90843b7556dc99762aa77c8772478615e865a969b5957cc6f3352ea281806957"
    end

    on_intel do
      url "https://github.com/nnutter/constable/releases/download/v0.9.3/constable_v0.9.3_linux_amd64.tar.gz"
      sha256 "50f323a1fd5b77fc1bb6450e11be6b485cceb2e7c7456a6f528e9266984a3c2e"
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
