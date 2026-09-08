class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.9.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.3/mise-v2026.9.3-macos-arm64.tar.gz"
      sha256 "59b75bbc8b394feb753dea579d77a4368611d978d9b8f91a01a7e62197341a1d"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.3/mise-v2026.9.3-macos-x64.tar.gz"
      sha256 "beecb23a4d0f6d40693b29ac3421050c8d7603bfaf68d6334048ebcf2a69ef94"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.3/mise-v2026.9.3-linux-arm64.tar.gz"
      sha256 "d1918155164a7e4ae4ae306e259b186065c0cfc1b993a954d6e033af0fa4fc5a"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.3/mise-v2026.9.3-linux-x64.tar.gz"
      sha256 "72de46e58238e3ae860e449adb9a35f4aba53679621c214dec03d68955fa4de8"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
