class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.7.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.3/mise-v2026.7.3-macos-arm64.tar.gz"
      sha256 "a1b6f0f1b79f956631d5f5310b826453739ad6310f555a423ca2a493deb922e9"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.3/mise-v2026.7.3-macos-x64.tar.gz"
      sha256 "266519e6137139f3c69971cf819a97cac380075155ddc7defa05980200b3511a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.3/mise-v2026.7.3-linux-arm64.tar.gz"
      sha256 "3a34c34eead36d00f71b9b3e744615de6b6091c6358fd614b89f2ea447d389ba"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.3/mise-v2026.7.3-linux-x64.tar.gz"
      sha256 "4cd83913f590ae3c7e06b1f49dc19ad521c284b6d82652782e1444b63f260c25"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
