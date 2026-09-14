class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.50.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.50.1/goose-aarch64-apple-darwin.tar.gz"
      sha256 "38c12865c13c4f820f92cf6f8b98b60d0d44a030c7e1d78a45ad817488b39d16"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.50.1/goose-x86_64-apple-darwin.tar.gz"
      sha256 "7cd653f5ad2f610489d94de6cd1557479cbbce4ca08e60c4d24ad0cdd9ce9bb7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.50.1/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b6ac038c2220fee7b56602fa63f9d7a3d6caf9de8d935e8ded435be12483ae5e"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.50.1/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2c21e82360f3670f52decb6dddd91857aa6c181cc30e4fddb699b3bf96189e2d"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
