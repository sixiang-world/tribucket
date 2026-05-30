class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.8.19"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.19/ccx-darwin-arm64"
      sha256 "e71acef4cb7910da77272167084cf091ccf92b87a74dccf0129c0cb6bd640a95"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.19/ccx-darwin-amd64"
      sha256 "e3f2d814b535097197041e7ae9a8c8aee1b403f5260c5a6f028704b5604bbea8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.19/ccx-linux-arm64"
      sha256 "d0bfda810c45818b70974c2f17106ccfbbcde12c0c296aac39aa17d894e548fe"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.19/ccx-linux-amd64"
      sha256 "46f3a7652a85c08f383d77a45a0cedd8a140924be457c0e6b241e414607df4d3"
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
