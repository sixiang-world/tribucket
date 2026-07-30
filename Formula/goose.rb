class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.45.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.45.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "90c50d653d7fd978ec5d436b548eca8613dc2d26d028b486b7c52271267ec500"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.45.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "8b1371cde21ee707a9a4ecbe730c20093e6489453b52ee89031f7187edc802e7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.45.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c9894106c90e404ac8b8d67c628aea2943dd6a1bc83bfd8e2171d482fa43d72a"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.45.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e0db638ac437ca0a60b0c1622f45322608d228d1a285214c3bf48fd9763346a5"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
