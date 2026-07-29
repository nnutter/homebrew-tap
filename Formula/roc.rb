class Roc < Formula
  desc "Fast, friendly, functional programming language"
  homepage "https://www.roc-lang.org/"
  license "UPL-1.0"
  head "https://github.com/roc-lang/roc.git", branch: "main"

  env :std

  depends_on "zig" => :build

  def install
    ENV["CC"] = DevelopmentTools.host_gcc_path if OS.linux?

    system "zig", "build", "roc", *std_zig_args
  end

  test do
    assert_match "Roc compiler version", shell_output("#{bin}/roc version")
  end
end
