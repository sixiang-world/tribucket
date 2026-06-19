class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.9.11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.11/ccx-darwin-arm64"
      sha256 "8c62fc8dc3440398c97a7c4aa6b5aaca604a2559d28d760f035a68db28797d7d"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.11/ccx-darwin-amd64"
      sha256 "6e1360e4e20a245c2fddc8e349216174082902fb1173ec0611b5899559d1d38d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.11/ccx-linux-arm64"
      sha256 "1f9f1035a76612a76749612beb6d78bb5ef782c9fc9b68b25f12737033ec1891"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.11/ccx-linux-amd64"
      sha256 "e27a0e68b86a4a017d8c912483c610e93d7b425321994df575f948f482b1796a"
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
