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
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.3.1/pooltime-1.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "36a7fff97c857d7dfec411084d4adfc70456bafecd64978694b594885527add2" # sha256 filled by release
    end
    on_intel do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.3.1/pooltime-1.3.1-x86_64-apple-darwin.tar.gz"
      sha256 "4d2a003b7b44b1a87398973af83afc8114508fb6ee3c69326c370499250df7b0" # sha256 filled by release
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.3.1/pooltime-1.3.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e3771a67aed018b8243b3253579c97ee6a93d2f7dc17db0170ba7b267fa145fb" # sha256 filled by release
    end
    on_intel do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.3.1/pooltime-1.3.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "2c0b9777867927902811ff9c8bb4ea45ccdf2e24e5908fa676d721448a26a9c1" # sha256 filled by release
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
