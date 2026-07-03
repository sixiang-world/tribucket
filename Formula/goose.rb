class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.41.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.41.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "19109847ae2bc7fe2c124a4fd06f02f2918477bbb1c4dc90ba6209614277a67c"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.41.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "70399e0eafe0415d1e8b9a876ff31904e5b792d6e9aa958d0462564ca6fa10da"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.41.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0b2cb6ac7dd2795897eaaf619068da236869e1128858412155e03cabbb94348e"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.41.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cd8e78455734d68cc43abc6dacea8e38ae00160fc1245ce959c3558fd61898a5"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
