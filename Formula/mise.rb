class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.9.15"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.15/mise-v2026.9.15-macos-arm64.tar.gz"
      sha256 "18407dc1ee5c2efdb808ac5272c989692c4ecc951933e84eb44cf5ac554ac2f9"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.15/mise-v2026.9.15-macos-x64.tar.gz"
      sha256 "8dadf477c1cfd6a235e926f6de867cf0dfacedeb0b7d30ad9c4583b5311989a1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.15/mise-v2026.9.15-linux-arm64.tar.gz"
      sha256 "254f60912e73c9420f03be8bab90ac80c0056db6826814b1a91cb4a0f872c1db"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.15/mise-v2026.9.15-linux-x64.tar.gz"
      sha256 "2148d2485d1e6e48eb918729d86af4ecd438f9b5b63be360fb26005c85f0d853"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
