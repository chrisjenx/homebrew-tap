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
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.3.0/pooltime-1.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "904109c695ccc239a9d7f8ed1230dd44a7e32e65ff98a15022e8f0e68cc75b84" # sha256 filled by release
    end
    on_intel do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.3.0/pooltime-1.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "29e9fa40e9a3e4fe33fee8d0b0d1b599cae96acb61e4a01b3930e44d1e15aa69" # sha256 filled by release
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.3.0/pooltime-1.3.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "71bdca84feb57b91dc44cf8c64c826888184b1b6804b766e2a0112807c333ff6" # sha256 filled by release
    end
    on_intel do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.3.0/pooltime-1.3.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7dbb65fae4a78028ad7754f91745784fb8e276b3bc58a9dbdf5767a2e84178b9" # sha256 filled by release
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
