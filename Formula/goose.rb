class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.46.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.46.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "690534819f2fe8242171eec1685144f2f55f6897568c149a226bc07c3b2f527c"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.46.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "0e7e9c62d3b33aac76bf3ac845251d995d6681dd64999ecbed4aa0be097019b3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.46.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e8c071ef75c1d8d036b3c4a791fb2be9e700f61a43e686c581e027b93e97dccf"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.46.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "23f0f37717406cc13bb55232f68932e152eec596643d26a92f9b21410bce4331"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
