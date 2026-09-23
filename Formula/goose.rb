class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.52.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.52.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "7674b0124aab685c71f8782fb7e65bac100c736ce3de0c9d3bf46ba07910e412"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.52.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "9fb8f60f36b2b2545f5e163a68c54b83c62e5c8baae4914d7aea377623a44cf9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.52.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ae602c4f6e9a785bf087da52c89908d4dc6aa605dcc17bf83293873f626d9c85"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.52.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4aee1f770b405c44194c0e9407df1fb06bda4c50eee935f0d8fd10731821cc5e"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
