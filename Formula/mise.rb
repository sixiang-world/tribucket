class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.10.18"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.18/mise-v2026.10.18-macos-arm64.tar.gz"
      sha256 "1b1cd6ad4a6176db5ddaf03bf71e131b26324af09cfcf14d7d7038bee60be85d"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.18/mise-v2026.10.18-macos-x64.tar.gz"
      sha256 "81931f325cfc97481faa558297dbd1595aa9c4e745fd09c02479593449e082c0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.18/mise-v2026.10.18-linux-arm64.tar.gz"
      sha256 "c5a49a47f8184f5649f3d8685b408bd72325a823f41cf618c60f3ffc303090a1"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.18/mise-v2026.10.18-linux-x64.tar.gz"
      sha256 "0d41b60745a6273a80089c86f80d8729042d2f57f87fda70aecc7d1c3ffbd3be"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
