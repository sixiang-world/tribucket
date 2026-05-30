class SingBox < Formula
  desc "The universal proxy platform"
  homepage "https://github.com/SagerNet/sing-box"
  version "1.13.12"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.12/sing-box-1.13.12-darwin-arm64.tar.gz"
      sha256 "43eef86f0ea4a79c3696974f397a963c46a457ee46d1ffac9aa913944a5fc986"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.12/sing-box-1.13.12-darwin-amd64.tar.gz"
      sha256 "f3275316451bf1983bc059599c69c8ed0232d53a619d15cfd535f95cc9a4477a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.12/sing-box-1.13.12-linux-arm64.tar.gz"
      sha256 "1ffa3b48ad6fa98f9fd810482e39bdd5b6157782ef11ce37d67bdcfd9338547a"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.12/sing-box-1.13.12-linux-amd64.tar.gz"
      sha256 "1540533adb3df24f5ad5f14b5c7ca3dbc2401b10a1c1eb278fcadcada47ec6c4"
    end
  end

  def install
    bin.install Dir["sing-box*"].first => "sing-box"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sing-box --version 2>&1", 1)
  end
end
