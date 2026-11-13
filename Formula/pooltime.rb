# frozen_string_literal: true

# Homebrew formula for pooltime; the published copy lives in chrisjenx/homebrew-tap (Formula/pooltime.rb).
# Installs the prebuilt release binary (the version is read from the URLs). After a release, run
# `packaging/homebrew/update-formula.sh <version>` to fill in the URLs and sha256s.
class Pooltime < Formula
  desc "Pool Claude Max and ChatGPT/Codex accounts behind one local endpoint"
  homepage "https://github.com/chrisjenx/pooltime"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.0.1/pooltime-1.0.1-aarch64-apple-darwin.tar.gz"
      sha256 "1ace40896683540f7833f71a7156a528d257113bf8d3e5e74955c44133f0290a" # sha256 filled by release
    end
    on_intel do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.0.1/pooltime-1.0.1-x86_64-apple-darwin.tar.gz"
      sha256 "82ac12fe3263013152e611b2fea0f7a227e11f4b067a84a19f773a065d447000" # sha256 filled by release
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.0.1/pooltime-1.0.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8f8d96bf52d2f3829eb735bc38ecf1249385e6f322dabd1e366d03d610ceb8d3" # sha256 filled by release
    end
    on_intel do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.0.1/pooltime-1.0.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "2f59a5169ee5c2066c6604a7c42f9b9f7e3db9bd3734b059f316c28441074c74" # sha256 filled by release
    end
  end

  def install
    bin.install "pooltime"
  end

  def caveats
    <<~EOS
      Finish with the setup wizard (accounts, background service, Claude Code profiles):
        pooltime setup

      Run the daemon either with `pooltime service install` (what `pooltime setup` offers)
      or with `brew services start pooltime`, not both: they would compete for the same port.

      Recommended on macOS, for notifications that open the dashboard when clicked:
        brew install terminal-notifier
    EOS
  end

  service do
    run [opt_bin/"pooltime", "serve"]
    keep_alive true
    log_path var/"log/pooltime.log"
    error_log_path var/"log/pooltime.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pooltime --version")
  end
end
