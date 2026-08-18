class Unpalm < Formula
  desc "Linux palm rejection filter for touchpads"
  homepage "https://github.com/rpodgorny/unpalm"
  url "https://static.crates.io/crates/unpalm/unpalm-0.1.0.crate"
  sha256 "a3160fa9c1df5edb3cedde2634bf06328b934901a95fa0c6a5d89d129d1bc4c0"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :crate
  end

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args

    service_wrapper = libexec/"unpalm-service"
    service_wrapper.write <<~SH
      #!/bin/sh
      set -eu

      set --
      if [ -f "#{etc}/unpalm.args" ]; then
        while IFS= read -r arg || [ -n "$arg" ]; do
          case "$arg" in
            ""|\\#*) continue ;;
          esac
          set -- "$@" "$arg"
        done < "#{etc}/unpalm.args"
      fi

      exec "#{opt_bin}/unpalm" "$@"
    SH
    chmod 0755, service_wrapper

    (buildpath/"unpalm.args").write <<~EOS
      # Add one unpalm argument per line. Blank lines and comments are ignored.
      # Example:
      # --margin-left
      # 30
    EOS
    etc.install "unpalm.args"
  end

  service do
    run [opt_libexec/"unpalm-service"]
    keep_alive true
    restart_delay 5
    log_path var/"log/unpalm.log"
    error_log_path var/"log/unpalm.log"
  end

  def caveats
    <<~EOS
      Start unpalm as a service:
        brew services start unpalm

      Configure the service by adding one command-line argument per line to:
        #{etc}/unpalm.args

      Blank lines and lines beginning with # are ignored. For example:
        --margin-left
        30
        --margin-right
        30

      Restart the service after changing the arguments:
        brew services restart unpalm

      The service runs as the user who starts it. That user must have access to
      the touchpad input device and /dev/uinput, usually through the input group.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unpalm --version")
    assert_match "Filter palm touches", shell_output("#{bin}/unpalm --help")
    assert_path_exists libexec/"unpalm-service"
  end
end
