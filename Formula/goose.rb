class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.53.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.53.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "134f331212d3ac480641d8b7b0e4155bdac581f881370b6129a38103debc686f"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.53.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "17d0635db643b627c3dfcd430776735bdff1594c8429edd0d75ccff247e35840"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.53.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "01a0ea109e1984e7a511ff3f99d1a29d32e6f90f0852b5a3b416499c8eaae567"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.53.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "deb2191a6b75acc0a20232fc5c52655ea2f9cc8fa2f5dffc8622e8d378a915dc"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
