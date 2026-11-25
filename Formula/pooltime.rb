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
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.4.0/pooltime-1.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "24955de3f0093cc6e1d9c739bf2afa509280ced63aab976f440891b15889d783" # sha256 filled by release
    end
    on_intel do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.4.0/pooltime-1.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "d170b363e29d519c0bae4a9d8de1ac128b45e5f99216088900cc9ae5e55ba001" # sha256 filled by release
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.4.0/pooltime-1.4.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "00eb7519198337f3c47ba289d3cdc38439bf76d93474b12c9a7f7172961f1932" # sha256 filled by release
    end
    on_intel do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.4.0/pooltime-1.4.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4c5b8783a247c9de50bb044dca42caea0e27a415b33e7a4237adec166dbd068a" # sha256 filled by release
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
