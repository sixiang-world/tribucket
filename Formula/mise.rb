class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.8.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.2/mise-v2026.8.2-macos-arm64.tar.gz"
      sha256 "6d7ff3ad671260413d7e9e13c8b4c2d610d7c303751e1d2acd9cda234fbe06cf"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.2/mise-v2026.8.2-macos-x64.tar.gz"
      sha256 "8d2b823965025473057120fe964f16575989df4103c051a8a007fe5bd1e884c4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.2/mise-v2026.8.2-linux-arm64.tar.gz"
      sha256 "bc2f838d484199e1af132f4cbed0a9a9a8b2a61e8b5203bc3ebc275d0ee69875"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.2/mise-v2026.8.2-linux-x64.tar.gz"
      sha256 "febda574ac4e036bf91e1ef9d33ec5e24dbfad6839eb0defa6abc12125186b74"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
