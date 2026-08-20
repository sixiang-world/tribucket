class Zellij < Formula
  desc "Terminal multiplexer with batteries included"
  homepage "https://github.com/zellij-org/zellij"
  version "0.45.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/zellij-org/zellij/releases/download/v0.45.0/zellij-aarch64-apple-darwin.tar.gz"
      sha256 "b3167bca9d75d2e2a676d1dabfa87537009f44b3878bc03fe6ed4cf651e337db"
    end
    on_intel do
      url "https://github.com/zellij-org/zellij/releases/download/v0.45.0/zellij-x86_64-apple-darwin.tar.gz"
      sha256 "ce499f2e5673750e22e980eb6bbe62fee9d8242cb6ff9d4e1ae33c7db1970d44"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/zellij-org/zellij/releases/download/v0.45.0/zellij-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d8b311d0f9ec7a03f3341563331aac12c9f52990ecc96a36ed44b1add9dfa035"
    end
    on_intel do
      url "https://github.com/zellij-org/zellij/releases/download/v0.45.0/zellij-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ab8b2494d80c20c07da4361041a25b96b93c73df992d2d54143e70fb9b1a1063"
    end
  end

  def install
    bin.install Dir["zellij*"].first => "zellij"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zellij --version 2>&1", 1)
  end
end
