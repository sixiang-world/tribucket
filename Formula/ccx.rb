class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.8.20"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.20/ccx-darwin-arm64"
      sha256 "a763d2cecc50fcf1fa36241e1cf741a87f4df9589d46b69f5be8c9a1abc0be90"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.20/ccx-darwin-amd64"
      sha256 "7fa8955556a3d2e71d21b5bfcf2f5e072eb51608844d612bc9141a18c176bebb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.20/ccx-linux-arm64"
      sha256 "4c06639983a65d23038e8ba00243465dd93c0baeabd04be9a4397e9ff76b9cf8"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.20/ccx-linux-amd64"
      sha256 "9f3c3a5625c142e0b4672a51637dd36433f418af66e129c627ed1eed29ea41b5"
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
