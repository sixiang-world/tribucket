class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.9.16"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.16/ccx-darwin-arm64"
      sha256 "511b4ee2c18bc251a6bd0ccbcf441851d4bf318671fd0c075f5d86318ec4663c"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.16/ccx-darwin-amd64"
      sha256 "c04340b26883a2d84ac2e8330d1d7fd5997ec35f89ac51bbc8b4aeb80612ea5d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.16/ccx-linux-arm64"
      sha256 "2da84438ad4f3f484d0992e93c06f145ec393f8d5cf3538419155d9e46826444"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.16/ccx-linux-amd64"
      sha256 "e5436b41e7795ffd6839ac34cc79452d4dd285293227bd1f5fad46ad6bb66829"
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
