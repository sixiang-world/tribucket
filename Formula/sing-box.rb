class SingBox < Formula
  desc "The universal proxy platform"
  homepage "https://github.com/SagerNet/sing-box"
  version "1.13.15"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.15/sing-box-1.13.15-darwin-arm64.tar.gz"
      sha256 "3452d866834c9572389e5ca73e60d4ee45a7d5b79332188c9a9e533c5fd40a6d"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.15/sing-box-1.13.15-darwin-amd64.tar.gz"
      sha256 "817e04f90f941b718fedd965ff05bfe72abfcc62952888b01751a6dec5547e14"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.15/sing-box-1.13.15-linux-arm64.tar.gz"
      sha256 "f0810bbb5722ae36635687c421019defcc8b328d31a0b3c287901f331747ca93"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.15/sing-box-1.13.15-linux-amd64.tar.gz"
      sha256 "a3a3ff223b23c3f4731d0a17cb0ef94c97ce257c70721a5b07dc7ca079203c9f"
    end
  end

  def install
    bin.install Dir["sing-box*"].first => "sing-box"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sing-box --version 2>&1", 1)
  end
end
