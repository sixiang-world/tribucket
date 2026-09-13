class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.9.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.6/mise-v2026.9.6-macos-arm64.tar.gz"
      sha256 "47d93429ab421a47e7ca158cdc97aad5c12475c7b306e600583b5b00d6922b8f"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.6/mise-v2026.9.6-macos-x64.tar.gz"
      sha256 "9acaa836e0ab8f476aadb5d1ee90d92c08bf4163e3ad4e9e4ba8e2223cceed1f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.6/mise-v2026.9.6-linux-arm64.tar.gz"
      sha256 "9d5d4c3187ccc2c5a9659be427231208eba689c8adcc0203004c4c2ef75caf8d"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.6/mise-v2026.9.6-linux-x64.tar.gz"
      sha256 "afa8079a2c75a48d8d39bbb6ca5566c652bda8ae49ce8ca1f41a72e80184140f"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
