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
      sha256 "5ad47fa92f87467cae0b7ba8ab1d340728b381462a5bbc1390f864cf9cf1262e"
    end
    on_intel do
      url "https://github.com/XIU2/CloudflareSpeedTest/releases/download/v2.3.5/cfst_linux_amd64.tar.gz"
      sha256 "1b1a2caa09246da589e1555a4a0aa7e4d84958dcb76d46e27b7f1216a4607e39"
    end
  end

  def install
    bin.install Dir["cfst*"].first => "cfst"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cfst --version 2>&1", 1)
  end
end
