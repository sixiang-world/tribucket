class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.10.24"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.24/mise-v2026.10.24-macos-arm64.tar.gz"
      sha256 "aa2fc59242db108f97ea9fb2d2e2cb42ff1467fcafe3c91e48d51c841ba67a65"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.24/mise-v2026.10.24-macos-x64.tar.gz"
      sha256 "83a36355bf6ee7c1660300e12dd94464de5c672dab1b8cc33ec4d19356e7ddac"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.24/mise-v2026.10.24-linux-arm64.tar.gz"
      sha256 "8c8f5d7f748bf3aef431dc50f0ad776270f36025c788aa21c74e2fabdbbd6d3e"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.24/mise-v2026.10.24-linux-x64.tar.gz"
      sha256 "9a6c9c55f5c6372d0af70a9979fe6d742aea3793267a929e1738022143c466cc"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
