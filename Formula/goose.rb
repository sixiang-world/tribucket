class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.54.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.54.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "feda29744cd4e13f9a5211a968ed47c67fb8fa79647f4d271d92d564998a393c"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.54.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "7cf5bcd0c23983993900a4da49c91a0eb30ad492d2ff85af3e03bb718fb9b8af"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.54.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0f174b5118a53888cd4e65b7ca9a4b72dd0b887e89142c8ce41e2409205e40d5"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.54.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ab396c95aebbd28b4d38c175234be8d4a3ea0c96e7ccb24c307e4618c9be57e1"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
