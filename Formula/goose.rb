class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.49.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.49.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "02549bf884f9002411a720c3648753633382a014b72199a61bdbc1ffa21fad57"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.49.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "88fa95b2f797a4513359f26f82fc48a3b1320857be26aaf8a96d6e518e845a5a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.49.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "833be4a86ed47e39e19f96e3fce01ee6170599c6e1220248c4e38187d245d3cc"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.49.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "38d5035e4a786f6b62abe0cd0f2bef7e6ac8041e3e006e2000561dd8df6aead3"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
