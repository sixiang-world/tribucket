class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.51.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.51.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "07699b8f00e1275219253b698c87cb1c2a28ab154e708098d60a383cf9e925df"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.51.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "7bb8e670059dfd8b2dc99076d128663be93f2de9e57141a62b2213c64899442d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.51.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e47da01a5378383b050bd736be3989d94ba8160d0a7e7df8280ddb2aec6fd306"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.51.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fc53761f5b907499d5fe21ef940c2bc57b2d93b4c8b858be24261cc136c6108e"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
