class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.8.12"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v#{version}/ccx-darwin-arm64"
      sha256 "064cdbeae0e754ad4787f2fdddb482d9f09d6acfaaabf892fafbdfde18e682e1"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v#{version}/ccx-darwin-amd64"
      sha256 "dcce3c236c0c13b5d8fce8f9be97eb606c509bed2810452e36ade400e5d6b9dc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v#{version}/ccx-linux-arm64"
      sha256 "ce77b36b58409d70a754c64e4e6e4b49158b1db31f2e76b6c01260cf26fa53fe"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v#{version}/ccx-linux-amd64"
      sha256 "960aab50ed9970d238c5dec28a77a623c168244c5a2ba30e5db25f174ccd7155"
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
