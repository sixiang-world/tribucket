class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.48.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.48.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "d502945fca78d8e58c8f56932973f454ad57d0754b272f5d44f696a4722da49a"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.48.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "17405c94bf07ccb8c2f5414ebb045dc409a2d54fa1b9127c8137a2add617213b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.48.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b6506e73ec15637ac7cd8d3c09df97f5eeff5400946a9e8f0d4c8f5905e53f3b"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.48.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3c38c790723fde4532357f35346b7190bd70d198e6be559f9ffeac4cf7c98152"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
