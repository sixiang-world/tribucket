class Zola < Formula
  desc "A fast static site generator in a single binary with everything built-in"
  homepage "https://github.com/getzola/zola"
  version "0.22.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/getzola/zola/releases/download/v0.22.1/zola-v0.22.1-aarch64-apple-darwin.tar.gz"
      sha256 "46ac45a9e7628dba8593b124ee8794f4f9aa1c6b569918ecd4bbc5d0be190515"
    end
    on_intel do
      url "https://github.com/getzola/zola/releases/download/v0.22.1/zola-v0.22.1-x86_64-apple-darwin.tar.gz"
      sha256 "3898709e154ae0593933264a540c869348bdb10d7f1b03a42dfb78d63703b3b5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getzola/zola/releases/download/v0.22.1/zola-v0.22.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8af437ec6352f33ccd24d7a1cfcb54a3db95d3ce376dc69525b4ef3fb6b8c1d1"
    end
    on_intel do
      url "https://github.com/getzola/zola/releases/download/v0.22.1/zola-v0.22.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0ca09aa40376aaa9ddfb512ff9ad963262ef95edb0d0f2d5ec6961b6f5cf22ef"
    end
  end

  def install
    bin.install Dir["zola*"].first => "zola"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zola --version 2>&1", 1)
  end
end
