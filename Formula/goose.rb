class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.37.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.37.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "d9e0a2a8feaa976e6e52a6fecad5cfe3801a7a1a59a102464d01c2829d33d00b"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.37.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "74eb0dab2f540451d6603ef0d8b510a1c796137507652b15854a03d371cf23ef"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.37.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a404b1c8b404b568631d85b7ac9dcfdfa7314113269d6a3b60f0869966580974"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.37.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d575073c059f22e0b697f1a0b502ecf629cfd4604a67e7659a8542a4ea7463bc"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
