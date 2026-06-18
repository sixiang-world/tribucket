class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.9.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.3/ccx-darwin-arm64"
      sha256 "541283e0aa87da948411cb6274efeabc0fa0d7181dcbfd39a70282ee2301446e"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.3/ccx-darwin-amd64"
      sha256 "81e07d6d530ed776547ffd53bde062821c241101148732df2ce826d6563828ff"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.3/ccx-linux-arm64"
      sha256 "42770dbefb30548d4bb92bd0379aa27379bc7b97411b03274533f102cc1a70d2"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.3/ccx-linux-amd64"
      sha256 "0b6dfa20af05039c12a8f7d867468a3705425402a421cba7fcf1faf1c66ba31e"
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
