class SingBox < Formula
  desc "The universal proxy platform"
  homepage "https://github.com/SagerNet/sing-box"
  version "1.14.2"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.14.2/sing-box-1.14.2-darwin-arm64.tar.gz"
      sha256 "925c5382eca8492b0150f868a6db20b18290a38700e621724b3703fd453e032d"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.14.2/sing-box-1.14.2-darwin-amd64.tar.gz"
      sha256 "b0bfb0dc70a5fc708710b9f5ea98b9ee76d40fa4169928d25d73edc4331df2fe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.14.2/sing-box-1.14.2-linux-arm64.tar.gz"
      sha256 "b43a1fb1bda131c6653576741ce527eb2bdeab7c9308ca90ee8b972abb7e4a7f"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.14.2/sing-box-1.14.2-linux-amd64.tar.gz"
      sha256 "a684484d7477d1437282ee411f4d131d0340aaad60a7868841ebd5d87dd8a0c6"
    end
  end

  def install
    bin.install Dir["sing-box*"].first => "sing-box"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sing-box --version 2>&1", 1)
  end
end
