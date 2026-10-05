class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.10.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.3/mise-v2026.10.3-macos-arm64.tar.gz"
      sha256 "28ecc8640b0a28dab52817766f37fecfd898f1dff82e03f36fcb072e971f9246"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.3/mise-v2026.10.3-macos-x64.tar.gz"
      sha256 "791b92b446729c53e6501acd2b84ea207f541659ca9d0480c9c70c291919a321"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.3/mise-v2026.10.3-linux-arm64.tar.gz"
      sha256 "e79866e32624b346f6854d93ca8a24294516cd7c0b48ce0e80af508fb7c3d8b8"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.3/mise-v2026.10.3-linux-x64.tar.gz"
      sha256 "04147c68e946902f5226dfdcd54d19907aed3cf54d95b2f27d2b9c778bb26f9e"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
