class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.10.23"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.23/mise-v2026.10.23-macos-arm64.tar.gz"
      sha256 "b9146f565a02c18dc117e63a9e59ec1cb5189d1602e2cc68b27c0322c2a5908d"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.23/mise-v2026.10.23-macos-x64.tar.gz"
      sha256 "38f56451213155378580a205ffb39ffd516e1ae60a748631a000ada7cc0a9e49"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.23/mise-v2026.10.23-linux-arm64.tar.gz"
      sha256 "4ae04207468000b50eb457610de80a0779b119ef32684e7489770934d36f9ad9"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.23/mise-v2026.10.23-linux-x64.tar.gz"
      sha256 "4be3403954d8e8cdeba93bddd10212ae8ecb69ce549833041805a027b803d996"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
