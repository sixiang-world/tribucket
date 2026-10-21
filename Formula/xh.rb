class Xh < Formula
  desc "Friendly and fast HTTP requests tool (HTTPie alternative)"
  homepage "https://github.com/ducaale/xh"
  version "0.26.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ducaale/xh/releases/download/v0.26.3/xh-v0.26.3-aarch64-apple-darwin.tar.gz"
      sha256 "50d61bd755942752b054297a1612ec191654f137f8939673cda83c686cb5b0f2"
    end
    on_intel do
      url "https://github.com/ducaale/xh/releases/download/v0.26.3/xh-v0.26.3-x86_64-apple-darwin.tar.gz"
      sha256 "b1c07e42238485bdcbed0982766f58b4daa631f0a33870100054ef5fbb4a3c4b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ducaale/xh/releases/download/v0.26.3/xh-v0.26.3-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a45d8cb6c234c6850f9fc2395fc3544ab7691fb511237f00179aedba1bcd525e"
    end
    on_intel do
      url "https://github.com/ducaale/xh/releases/download/v0.26.3/xh-v0.26.3-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cbbf53bd76007d57d95e4bed8ba7fb3b7fcec22af4bdfc1ff119cd5de351e74f"
    end
  end

  def install
    bin.install Dir["xh*"].first => "xh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xh --version 2>&1", 1)
  end
end
