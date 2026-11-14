class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.59.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.59.1/goose-aarch64-apple-darwin.tar.gz"
      sha256 "25d703112d5eacd5b5d2e880b4fd85d980de1c9d15ac42af939b9fb22ac895f9"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.59.1/goose-x86_64-apple-darwin.tar.gz"
      sha256 "0cbc48b9cc8b5d104dba736186de7275dcab7fc360aab07163ea9eee03314362"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.59.1/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e3619b2ebf76dbbe8924561fd748220f289a34671e2757cda1cd833e44194f8e"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.59.1/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "04c08900ab2ae78b8e2f556f1ed535a91b61c080a3ff62e9fd8b280cceb544ef"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
