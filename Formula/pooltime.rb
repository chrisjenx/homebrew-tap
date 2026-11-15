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
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.2.1/pooltime-1.2.1-aarch64-apple-darwin.tar.gz"
      sha256 "d8438335dc8e5edc68282f7873be11af4da74114c3bb3fe53c67a57714551317" # sha256 filled by release
    end
    on_intel do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.2.1/pooltime-1.2.1-x86_64-apple-darwin.tar.gz"
      sha256 "3ab5fcab1b366d0f041188e1dfafb4060d9627eb9af6222e3cd4fb9123419eca" # sha256 filled by release
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.2.1/pooltime-1.2.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "fd5869af5d27b5fd534b6c153c3b692bc7c4746d4f6a9e045768ee892f842187" # sha256 filled by release
    end
    on_intel do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.2.1/pooltime-1.2.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a1c7074b687f70f77214e72ff5b79b2339b54f2df185343190ecb941b863b4d5" # sha256 filled by release
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
