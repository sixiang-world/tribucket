class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.11.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.11.4/mise-v2026.11.4-macos-arm64.tar.gz"
      sha256 "d37c01389b0918a19bbf763ee8ed339e533eebdb281be4911e9ad71d00b51477"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.11.4/mise-v2026.11.4-macos-x64.tar.gz"
      sha256 "b8a74f677aba6a8e418c82870c2321a563391e828b0a2474f61497e2801177de"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.11.4/mise-v2026.11.4-linux-arm64.tar.gz"
      sha256 "e168248871cd4f958bb1597dc74d03ec65634bb54bf49c80dbb7999a7ba88471"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.11.4/mise-v2026.11.4-linux-x64.tar.gz"
      sha256 "e9652ecdc9ac990662ba8346b2b3da95ad9c890ed73768ea4675ef721dcef37e"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
