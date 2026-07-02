class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.40.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.40.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "1792256d8947bfd378a1749d76a21df9e1cf5bd613c9dc55edea33ec379f3cf4"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.40.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "646d56d24678a92c25a6a09e5d0d58fd74525786c930fb430a6701d48229c498"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.40.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c4bd4222799beb5ad124dde80b458574e17734cfb054edb50591a5a9c24facd0"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.40.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e9a0dbdcbe4c75ef4fa4cfca97e507f53c86bae19a3e0c76e6807eaaa04a05b8"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
