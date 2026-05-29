class Xh < Formula
  desc "Friendly and fast HTTP requests tool (HTTPie alternative)"
  homepage "https://github.com/ducaale/xh"
  version "0.25.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ducaale/xh/releases/download/v0.25.3/xh-v0.25.3-aarch64-apple-darwin.tar.gz"
      sha256 "3886af1df744a44f6f8da37d51e3f733c14b35aeb3f46828ee528970ad708951"
    end
    on_intel do
      url "https://github.com/ducaale/xh/releases/download/v0.25.3/xh-v0.25.3-x86_64-apple-darwin.tar.gz"
      sha256 "ef0bd8fe2752abd84202d0b0ac5d4943712ce3c464d70a679b140ca2a0a475cf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ducaale/xh/releases/download/v0.25.3/xh-v0.25.3-aarch64-unknown-linux-musl.tar.gz"
      sha256 "042f504048281e0042d99230750ee0a314d0a7273c4398d62a66896478b53a86"
    end
    on_intel do
      url "https://github.com/ducaale/xh/releases/download/v0.25.3/xh-v0.25.3-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fc738e616b327e7a10256e206c78073bfeed95d73af6ba9ced4c5eb20ac8d717"
    end
  end

  def install
    bin.install Dir["xh*"].first => "xh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xh --version 2>&1", 1)
  end
end
