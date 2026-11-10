class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.58.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.58.1/goose-aarch64-apple-darwin.tar.gz"
      sha256 "9df32ef39ed696911ea2931435660393020e839013d0ccad30f82d68dfd49bce"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.58.1/goose-x86_64-apple-darwin.tar.gz"
      sha256 "6714c150ed5c95964d26ef9e819d0990340f39d2a1e83fc0a9f78d63c824e63c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.58.1/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "20d9586ac7d37d2700d41d85d0051547a959ae96576aae6cbd290f77b5605a61"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.58.1/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "43adae6abf10d40d5b1d5cd23bcf6481ef72fddede8fe9a8577c385e325cba68"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
