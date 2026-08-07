class Zola < Formula
  desc "A fast static site generator in a single binary with everything built-in"
  homepage "https://github.com/getzola/zola"
  version "0.23.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/getzola/zola/releases/download/v0.23.2/zola-v0.23.2-aarch64-apple-darwin.tar.gz"
      sha256 "0d0a2109090aee4901b52d8d4a552d62b7c64fc0bec4e97f23b40e6d1483bdc1"
    end
    on_intel do
      url "https://github.com/getzola/zola/releases/download/v0.23.2/zola-v0.23.2-x86_64-apple-darwin.tar.gz"
      sha256 "9738c313e83c6c1ba7f9101a9712708917aa412f071df42cee2c37b373a5e5c5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getzola/zola/releases/download/v0.23.2/zola-v0.23.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e00a87147e2f870df42b29187452b48c660ee3d4c0dcee200af5d549870637be"
    end
    on_intel do
      url "https://github.com/getzola/zola/releases/download/v0.23.2/zola-v0.23.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e2e87de440e69524619cf6067a5bc534ff770d4ce0fc30a3c7c7b3092f17b045"
    end
  end

  def install
    bin.install Dir["zola*"].first => "zola"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zola --version 2>&1", 1)
  end
end
