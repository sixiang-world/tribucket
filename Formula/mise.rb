class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.8.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.3/mise-v2026.8.3-macos-arm64.tar.gz"
      sha256 "46f2ff77244fd7caa9602fdb190e5db3da3d60ed5d1b579512aad942303a477a"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.3/mise-v2026.8.3-macos-x64.tar.gz"
      sha256 "15310f580fce8b3dad93e5e1a916592651dfdb7fa9a6904cb60ee52e5d8cbecd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.3/mise-v2026.8.3-linux-arm64.tar.gz"
      sha256 "8d0c6142607d814279de0e06f53c9e896b5d267bbced9ee6e2d9e1547fccca8f"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.3/mise-v2026.8.3-linux-x64.tar.gz"
      sha256 "8aaf21cc4b36681e90a96e9cdf13e5d7511e9773733f741b1a5f7756ba53b5fc"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
