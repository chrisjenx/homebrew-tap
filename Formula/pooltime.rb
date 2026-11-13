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
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.1.0/pooltime-1.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "178ba71de6d02ed58ce94cee20381f5452cd44b5e3d072df789825f7e6ab291f" # sha256 filled by release
    end
    on_intel do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.1.0/pooltime-1.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "062749a3ac00a89b641f55c8bb36bda5e248bb9245d0ecc21a3ea0162e69a607" # sha256 filled by release
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.1.0/pooltime-1.1.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "dfa1cf71505f2d494df58b710a2c11ed539c0b4a589cb6181a73ccf07215ad20" # sha256 filled by release
    end
    on_intel do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.1.0/pooltime-1.1.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3090204227c8b41a04fa023427d6932fff23a410d1f6fbb9f7c5a95b529a57a2" # sha256 filled by release
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
