class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.56.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.56.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "52f3f8d62e3d144c5de70c5c471de39d8b92c24d41d5b3436eb8bab11ba4bc24"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.56.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "66f7bd043a480f69cdc033a41b542779fb0199c2f79154fac4fcea1b7f6e0c0c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.56.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "26bcb7d3f55aac485a91d81cbdecd8d90e5af1acadeca6e580b4d58b64a888e4"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.56.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "225a929b35b5130fb691eafdb50be236f2c0a150019b53973775938f8f19c281"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
