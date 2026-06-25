class SingBox < Formula
  desc "The universal proxy platform"
  homepage "https://github.com/SagerNet/sing-box"
  version "1.13.14"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.14/sing-box-1.13.14-darwin-arm64.tar.gz"
      sha256 "73e8967b0fc08e17bce4263ca56ebc394822401a16497a1c4e02316c888202ab"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.14/sing-box-1.13.14-darwin-amd64.tar.gz"
      sha256 "5245d645e847f90bb708da74bc020ae078c28489690756419685c04f56b4e3bb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.14/sing-box-1.13.14-linux-arm64.tar.gz"
      sha256 "4742df6a4314e8ecc41736849fca6d73b8f9e91b6e8b06ee794ff17ba180579e"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.14/sing-box-1.13.14-linux-amd64.tar.gz"
      sha256 "f48703461a15476951ac4967cdad339d986f4b8096b4eb3ff0829a500502d697"
    end
  end

  def install
    bin.install Dir["sing-box*"].first => "sing-box"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sing-box --version 2>&1", 1)
  end
end
