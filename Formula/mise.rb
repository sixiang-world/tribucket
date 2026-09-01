class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.9.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.0/mise-v2026.9.0-macos-arm64.tar.gz"
      sha256 "1f71af1bb6d43cb4d3bc949c8c3d8bb62c65835577f9c6c9dbdf295ec8f63ead"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.0/mise-v2026.9.0-macos-x64.tar.gz"
      sha256 "2f2040638a897e5f3d54a29ca52aecbe050bc2e8eaad5880d79b2f50fa7c3653"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.0/mise-v2026.9.0-linux-arm64.tar.gz"
      sha256 "00714b9c7449a91b8b053f86391fb23f19901250c609920847a56f842c41b810"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.0/mise-v2026.9.0-linux-x64.tar.gz"
      sha256 "9499e503b866130b2f19bb11ec04d87a11ed81acc8d6032b8832ea08d4db7ce8"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
