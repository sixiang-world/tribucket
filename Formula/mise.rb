class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.6.12"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.6.12/mise-v2026.6.12-macos-arm64.tar.gz"
      sha256 "d12c07f0e270d3cc65c25ba4eb7c789fd7ee5380965b3fa31426be1d0b9deed9"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.6.12/mise-v2026.6.12-macos-x64.tar.gz"
      sha256 "7dd80a907340fa319ce51c351b67c6e4d2ba4017bf58ca0dbbec20e38af61607"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.6.12/mise-v2026.6.12-linux-arm64.tar.gz"
      sha256 "6cef74020f98b06a62d6f925c116235b629b4badb197b20a33217bff96d60f0f"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.6.12/mise-v2026.6.12-linux-x64.tar.gz"
      sha256 "cc9b5bc96ba616d88d0ee515196bec6871a33d64cec774924fbfaa2717a921fd"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
