class Cloudflarespeedtest < Formula
  desc "Test Cloudflare CDN latency and speed, find the fastest IP"
  homepage "https://github.com/XIU2/CloudflareSpeedTest"
  version "2.3.5"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/XIU2/CloudflareSpeedTest/releases/download/v2.3.5/cfst_darwin_arm64.zip"
      sha256 "0623f6d24c939e3d3716f556f4d39c7b8781cf6600ee838a1b64e6b2fe4609dc"
    end
    on_intel do
      url "https://github.com/XIU2/CloudflareSpeedTest/releases/download/v2.3.5/cfst_darwin_amd64.zip"
      sha256 "66ce3ae89430e851cab9710d54b6d91324e0aae255f0c92a91072d57724561d5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/XIU2/CloudflareSpeedTest/releases/download/v2.3.5/cfst_linux_arm64.tar.gz"
      sha256 "0ac992fcf24d4684caed33620deb9b83ce82f32d2418dc1f90be490ce5900300"
    end
    on_intel do
      url "https://github.com/XIU2/CloudflareSpeedTest/releases/download/v2.3.5/cfst_linux_amd64.tar.gz"
      sha256 "c4c8fc76b4e1bf2bdb5ced8b765956d82dda7bc4eb59df5c04053f0f7db98d90"
    end
  end

  def install
    bin.install Dir["cfst*"].first => "cfst"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cfst --version 2>&1", 1)
  end
end
