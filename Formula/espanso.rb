class Espanso < Formula
  desc "Cross-platform text expander written in Rust"
  homepage "https://espanso.org/"
  url "https://github.com/espanso/espanso/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "32b315a813114b28ef3ee74c5d2ce0bfc2f75a0bd9a4141c7465cd0b00fdf34c"
  license "GPL-3.0-or-later"
  head "https://github.com/espanso/espanso.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  option "with-x11", "Build with X11 support instead of Wayland"

  depends_on "gcc" => :build
  depends_on "make" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "dbus"
  depends_on "libcap"
  depends_on "libpng"
  depends_on "libxkbcommon"
  depends_on :linux
  depends_on "wl-clipboard"
  depends_on "wxwidgets"

  def install
    ENV["WX_CONFIG"] = formula_opt_bin("wxwidgets")/"wx-config"

    gcc = Formula["gcc"]
    ENV["CC"] = gcc.opt_bin/"gcc-#{gcc.version.major}"
    ENV["CXX"] = gcc.opt_bin/"g++-#{gcc.version.major}"

    features = if build.with?("x11")
      "modulo,vendored-tls"
    else
      "modulo,vendored-tls,wayland"
    end

    system "cargo", "install", "--no-default-features",
           *std_cargo_args(path: "espanso", features: features)
  end

  def caveats
    s = ""
    unless build.with?("x11")
      s += <<~EOS
        Wayland needs capabilities before first start (re-run after upgrades):
          sudo setcap "cap_dac_override+p" #{opt_bin}/espanso

      EOS
    end
    s += <<~EOS
      Register and start Espanso:
        espanso service register
        espanso start
    EOS
    s
  end

  test do
    # espanso --version exits non-zero even on success
    assert_match version.to_s, shell_output("#{bin}/espanso --version", 1)
    assert_match "USAGE", shell_output("#{bin}/espanso --help")
  end
end
