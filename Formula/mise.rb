class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.9.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.9/mise-v2026.9.9-macos-arm64.tar.gz"
      sha256 "0f13937fb7c548c4f39e3faca914f8c591c5b43a150b80db8a178afc60d4f581"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.9/mise-v2026.9.9-macos-x64.tar.gz"
      sha256 "e22ecf26ebdfbbf0d3ba2deaa3866699c555e50ad6d900894da0d7f206a4c95a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.9/mise-v2026.9.9-linux-arm64.tar.gz"
      sha256 "5f72efaa1265c9c3562ecf8d22e6623b5278700bd7ef1014a785d0ce1d1a90b2"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.9/mise-v2026.9.9-linux-x64.tar.gz"
      sha256 "e4767e4854af5daeff2191b2bbdc94f834742a23efad591dbd33187861d41604"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
