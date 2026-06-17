class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.38.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.38.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "3c6b7cf321610dd8a20307ca76a4c75608fb5fe032d4f9fddf9ee1c761f1d4a9"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.38.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "123364a43d295b2f33e245d4869ec6fe1e42991aee89e5eb41efee030e7578de"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.38.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "601242ad33fbbd70b3a72181aa1d449096f69b608152124ef16757019dec3ec0"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.38.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "70532ea2ce7d38461cb670e696fa2b93674d16175ec393f2a954ef624161ff9d"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
