class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.59.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.59.2/goose-aarch64-apple-darwin.tar.gz"
      sha256 "7e7f5ac8bd3590a29fddc0f5121a6975e907fb57f274d3c4431963ee546fb435"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.59.2/goose-x86_64-apple-darwin.tar.gz"
      sha256 "ccbf40a585a40c0fb221afbccee725e293ce8c32d10d86ba38be5643c5f54d7d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.59.2/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ec2e0aded1e2aba8d310727a5138f2e3cce0769f2611fbe196ed014c31ce370a"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.59.2/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c63cf82953e968d84b7542eb38a621dfdb5050b967728ed363517be5cdc666ea"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
