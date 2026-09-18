class Tom < Formula
  desc "Generate a text map of Go source code structure"
  homepage "https://github.com/nnutter/tom"
  url "https://github.com/nnutter/tom/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "8f5be04cde729531899b28aa6b9e374cba10deb7d28d08c409fc8bda66b6a17d"
  license "MIT"
  head "https://github.com/nnutter/tom.git", branch: "master"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X main.version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"tom")
    generate_completions_from_executable(bin/"tom", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tom --version")
    assert_match "tomography", shell_output("#{bin}/tom --help")

    (testpath/"main.go").write <<~EOS
      package main

      // Hello says hi.
      func Hello() {}

      func main() { Hello() }
    EOS
    assert_match "package main", shell_output("#{bin}/tom --depth 0 #{testpath}")
    assert_match "#compdef tom", (zsh_completion/"_tom").read
    assert_match "bash completion V2 for tom", (bash_completion/"tom").read
    assert_match "fish completion for tom", (fish_completion/"tom.fish").read
    assert_match "powershell completion for tom", (pwsh_completion/"_tom.ps1").read
  end
end
