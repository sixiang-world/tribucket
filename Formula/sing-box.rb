class SingBox < Formula
  desc "The universal proxy platform"
  homepage "https://github.com/SagerNet/sing-box"
  version "1.13.13"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.13/sing-box-1.13.13-darwin-arm64.tar.gz"
      sha256 "4ac414d4ede9ec21bc79d8ccf40b4679429203b9e06ad96d2d8d34c0fe940558"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.13/sing-box-1.13.13-darwin-amd64.tar.gz"
      sha256 "477afd64ad7751214f01338ba244265ecc223966ddb58214963f526dca7f424e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.13/sing-box-1.13.13-linux-arm64.tar.gz"
      sha256 "d7fab87b921933eb281d8ee7bd5377cdd8228089f1f7c807c9363a6a2329286c"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.13/sing-box-1.13.13-linux-amd64.tar.gz"
      sha256 "bb99cabf47694625db421ee17898f36cdc1f9c2cb5decf65b12bac8d8437e842"
    end
  end

  def install
    bin.install Dir["sing-box*"].first => "sing-box"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sing-box --version 2>&1", 1)
  end
end
