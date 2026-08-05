class Zola < Formula
  desc "A fast static site generator in a single binary with everything built-in"
  homepage "https://github.com/getzola/zola"
  version "0.23.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/getzola/zola/releases/download/v0.23.1/zola-v0.23.1-aarch64-apple-darwin.tar.gz"
      sha256 "674e5a8bf40747053a6157bf4aa7895bb718a61eb8303f1863f63a398460ae8b"
    end
    on_intel do
      url "https://github.com/getzola/zola/releases/download/v0.23.1/zola-v0.23.1-x86_64-apple-darwin.tar.gz"
      sha256 "3b7173456d010dcbbedefea6a27524531b8c7d2540a2c98eb8933844d7531a20"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getzola/zola/releases/download/v0.23.1/zola-v0.23.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0882d5770f3fcc5a6e64aa7f794ec607204c93b3ead228108455468ee16ff5c4"
    end
    on_intel do
      url "https://github.com/getzola/zola/releases/download/v0.23.1/zola-v0.23.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5660d2848a4a294422f16687c9949c0b689bc5ebd236a649c75bb4c91e159c89"
    end
  end

  def install
    bin.install Dir["zola*"].first => "zola"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zola --version 2>&1", 1)
  end
end
