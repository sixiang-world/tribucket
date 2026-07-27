class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.7.15"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.15/mise-v2026.7.15-macos-arm64.tar.gz"
      sha256 "4898a07e7b501e01ee9ba11df96a0141460b4eef30be8e7cb0f3d698d4222d07"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.15/mise-v2026.7.15-macos-x64.tar.gz"
      sha256 "a72eaa7ff33d1d69847fc181f774f26f74c37c0624f4492bd3bfe88e1874005b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.15/mise-v2026.7.15-linux-arm64.tar.gz"
      sha256 "0c2ca4d4ee79720a08d2c5f54c986450348b0fe25ace2bf9998dbe6c6761bf16"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.15/mise-v2026.7.15-linux-x64.tar.gz"
      sha256 "0785821a617e85197104c021835072ca3f4fcdda143538293a30593acc258969"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
