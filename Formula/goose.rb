class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.39.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.39.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "247eb9f603f43c5c1cb558fe3e16c4669f80254513fbdcf02a26ffc996728307"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.39.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "81820b6da617172139a7a5330930ae74d5f20523361029679e17adee7711a4d5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.39.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "74610e115703ef4624a362f8ab7fb03b458bc0c68dd618fb0895f864fa15ea38"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.39.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f4ad0867430d3420ea60bc3bb36a68f6f5669c060ce6de952fe9a27d8a7e0767"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
