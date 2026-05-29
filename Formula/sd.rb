class Sd < Formula
  desc "Intuitive find & replace CLI (sed alternative)"
  homepage "https://github.com/chmln/sd"
  version "1.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/chmln/sd/releases/download/v1.1.0/sd-v1.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "4bd3c09226376ca0a1d69589c91e86276fae36c5fbaaee669afce583f6682030"
    end
    on_intel do
      url "https://github.com/chmln/sd/releases/download/v1.1.0/sd-v1.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "1fca1e9c91813a8aac6821063c923107ba0f66a83309e095edcd3b202f67f97e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/chmln/sd/releases/download/v1.1.0/sd-v1.1.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ec8c93c0533ff21f4851d11566808d4082544baf063d9b96ea77c27e98b7cd99"
    end
    on_intel do
      url "https://github.com/chmln/sd/releases/download/v1.1.0/sd-v1.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3613eca74cd686739bb5a6d68319aa56c747e7315274d02323a2ca2b1c5d82d2"
    end
  end

  def install
    bin.install Dir["sd*"].first => "sd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sd --version 2>&1", 1)
  end
end
