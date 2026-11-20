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
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.3.2/pooltime-1.3.2-aarch64-apple-darwin.tar.gz"
      sha256 "956b523d74650bf9a1801833874e630eab7e9f60b53c54b354883a8db7d97270" # sha256 filled by release
    end
    on_intel do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.3.2/pooltime-1.3.2-x86_64-apple-darwin.tar.gz"
      sha256 "868811a40d6c3999ee33e966859c6acdbae632c41b96af8e141a93a2f3975f6e" # sha256 filled by release
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.3.2/pooltime-1.3.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "5d5e77f124d4014d1853f78f4d34c25b2901c90c94e513e049fa2f43c2f86da5" # sha256 filled by release
    end
    on_intel do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.3.2/pooltime-1.3.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ca753aef7ab4065afd7ad618f69a42ee8753fb9ff2c49efc0312dd9b978896fb" # sha256 filled by release
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
