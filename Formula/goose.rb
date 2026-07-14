class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.43.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.43.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "619be6a8de423e71229a66bf59558dd33625d837f9d6adc0eae2a07f1ebe9fe6"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.43.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "562102c021a4ce8bff908e0e3058a4b53e12950c5cabae848f647b4d10db158b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.43.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e0aacbda8f8177c23e5c8199d107faf117b40041eca0ff82207cc7888c044479"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.43.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a9a96f559a8b5f20b11597b78e4aa5bb0b9b29796ec4f808ca466a3f59a5ec20"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
