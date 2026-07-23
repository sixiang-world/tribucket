class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.44.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.44.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "fa17293d48778ace60bf3cdcfbb2fcbd74628216a22cc45b020bd1ca45b42170"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.44.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "3a4f89bbc14448ca4cb8f28b7b41e7e891c130a546d6ee6acd8cb2ff77cb3b4d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.44.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "da6cb005d421b0bdcb83fe8386ba5ae8060ef17adf64641a684d4fc4b9e1c15f"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.44.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "07febc8b4f73bdfdc3ece3d34d0e21b005f3a4f43008f95b85d6538da8f6bac1"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
