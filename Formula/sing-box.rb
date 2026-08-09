class SingBox < Formula
  desc "The universal proxy platform"
  homepage "https://github.com/SagerNet/sing-box"
  version "1.13.18"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.18/sing-box-1.13.18-darwin-arm64.tar.gz"
      sha256 "9fbc05946b584423457a2778035e0cee2d9b239a4af5ae1932d9b79991149107"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.18/sing-box-1.13.18-darwin-amd64.tar.gz"
      sha256 "500f0decfc21f7cdb2aaa4fe193b7857a41b07c38ee3a0b15bd53e3c7af3671c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.18/sing-box-1.13.18-linux-arm64.tar.gz"
      sha256 "a894f6152cade4a2c9d062762d54dea0c1aee673ab4759e0829e19cace932719"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.18/sing-box-1.13.18-linux-amd64.tar.gz"
      sha256 "d34d987ed6ae39ca3760269264fb502b867e5477db45518c829b07776245c495"
    end
  end

  def install
    bin.install Dir["sing-box*"].first => "sing-box"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sing-box --version 2>&1", 1)
  end
end
