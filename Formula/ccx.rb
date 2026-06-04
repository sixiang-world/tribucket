class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.8.23"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.23/ccx-darwin-arm64"
      sha256 "c08a984ca392bbfe1d3099bdc8cb72da1d0bf8936d0c26e7ef3353f4ad56edea"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.23/ccx-darwin-amd64"
      sha256 "299e541f713c983a283be20c8cbe5c543d3f59d4e9272284376be0b67405433c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.23/ccx-linux-arm64"
      sha256 "bba54078898914eb1e59bba69f2bae266eec4d9bad219fa04c9e140c3b8c284e"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.23/ccx-linux-amd64"
      sha256 "4d166e0348965c2508b457cf446c23a9bc2a6166c52802be431a1ab1c5b77ef3"
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
