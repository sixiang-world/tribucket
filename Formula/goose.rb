class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.47.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.47.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "f3d6393ab88b96f037214a12c642cebf046cc56c09107ffdacb37cf897976722"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.47.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "03a9bdbdc361a023166d3eff4af701816fdfefb66190ebf976eba8d85b0f8031"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.47.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d51c19d0eb7d97c1916d39a5ae01af2cf8a27665165b5082190ab76de64914d1"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.47.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "446e014bd0412fcedbeb2dee845d6d5bfcad630944b01280fb35f6e4feb1112a"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
