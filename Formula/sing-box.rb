class SingBox < Formula
  desc "The universal proxy platform"
  homepage "https://github.com/SagerNet/sing-box"
  version "1.13.21"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.21/sing-box-1.13.21-darwin-arm64.tar.gz"
      sha256 "62bca85bf08b9145288729cf010c98ea9877b8086f7369cde9e127012d509424"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.21/sing-box-1.13.21-darwin-amd64.tar.gz"
      sha256 "61093d79211a6ae7b707d30f07be35b1167ca8366bf0dbc06ee5fb35c90dc9e8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.21/sing-box-1.13.21-linux-arm64.tar.gz"
      sha256 "3e30b876c9a93c19e503e2a2d6249cf05e6a26766553d4b61e1daf48223f304f"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.21/sing-box-1.13.21-linux-amd64.tar.gz"
      sha256 "24f9ef8e7234e13e71e74c3598a4164c5fe07b7b67ccc6e96cf68b54789f72cd"
    end
  end

  def install
    bin.install Dir["sing-box*"].first => "sing-box"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sing-box --version 2>&1", 1)
  end
end
