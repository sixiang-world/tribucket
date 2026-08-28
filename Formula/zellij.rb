class Zellij < Formula
  desc "Terminal multiplexer with batteries included"
  homepage "https://github.com/zellij-org/zellij"
  version "0.45.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/zellij-org/zellij/releases/download/v0.45.1/zellij-aarch64-apple-darwin.tar.gz"
      sha256 "c029ba4fe1927b79ad9f0cdd59155c4dff80777863c85857d4d09b88b56f9891"
    end
    on_intel do
      url "https://github.com/zellij-org/zellij/releases/download/v0.45.1/zellij-x86_64-apple-darwin.tar.gz"
      sha256 "8e8bea22737d1652278c51fc5c26c7c22c9855d0ebb9634a84b8873823093114"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/zellij-org/zellij/releases/download/v0.45.1/zellij-aarch64-unknown-linux-musl.tar.gz"
      sha256 "05f0802afadd53f8db9514e7cae53c9ae8432fed1b35b8294aa816ee3044a16b"
    end
    on_intel do
      url "https://github.com/zellij-org/zellij/releases/download/v0.45.1/zellij-x86_64-unknown-linux-musl.tar.gz"
      sha256 "40bcc2e03f5d5ae8e054e39f676081fe12ab70871506996ba595834c3718eefc"
    end
  end

  def install
    bin.install Dir["zellij*"].first => "zellij"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zellij --version 2>&1", 1)
  end
end
