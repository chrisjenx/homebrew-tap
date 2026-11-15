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
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.2.0/pooltime-1.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "6c0fd7da80770d81a4c5286af10e995ea95d31bb87653a81ad41a2ca92f411b4" # sha256 filled by release
    end
    on_intel do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.2.0/pooltime-1.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "e3d86817d3edcf2c5e9d6682430d2a75a49d482c5aa0bc0c65b9531c157512ba" # sha256 filled by release
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.2.0/pooltime-1.2.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4745a1d88ea804e570de9d8b18bf3414b4bf1fad54b7ee51e377ebd94a90ac05" # sha256 filled by release
    end
    on_intel do
      url "https://github.com/chrisjenx/pooltime/releases/download/v1.2.0/pooltime-1.2.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4babec0e19f5dc3101155ceb681dce86172fccd797f82b50cd4d10f2d0d55bdf" # sha256 filled by release
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
