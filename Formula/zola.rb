class Zola < Formula
  desc "A fast static site generator in a single binary with everything built-in"
  homepage "https://github.com/getzola/zola"
  version "0.23.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/getzola/zola/releases/download/v0.23.3/zola-v0.23.3-aarch64-apple-darwin.tar.gz"
      sha256 "5e3575cc7b054f20002eecf2c2d9850f0771f4f291f5c68ae748c72005679407"
    end
    on_intel do
      url "https://github.com/getzola/zola/releases/download/v0.23.3/zola-v0.23.3-x86_64-apple-darwin.tar.gz"
      sha256 "1c0a0cc90653b15267d9f6a52e2ff52ee2a442af18235f9dbf5ca5cc30ba137e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getzola/zola/releases/download/v0.23.3/zola-v0.23.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "15387186bc8fde347dd931490afafe462ccc391db049e9e19c80a48dd060a8c9"
    end
    on_intel do
      url "https://github.com/getzola/zola/releases/download/v0.23.3/zola-v0.23.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f07c92607e5745268b576bd325ceef3a582aada253bb64db8d92a8a85303d958"
    end
  end

  def install
    bin.install Dir["zola*"].first => "zola"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zola --version 2>&1", 1)
  end
end
