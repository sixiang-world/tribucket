class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.36.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.36.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "c26ddbba11f6e3ddb966c7c3d288df9e1844b539055373df5f76369a0baea2fa"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.36.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "c1391359e8ce79eef2b8182c3d7da4da5aed97835619ce5ee2196541a11d6b55"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.36.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4d90d78d5620509817ddd3f5432bc13bbe3b73777ac9954cd9ef712c6d8bbe0e"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.36.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "462cdc2474cfbe91ec8f95e7d2fba0d3ab16238799ca5d2218ac867da7954287"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
