class SingBox < Formula
  desc "The universal proxy platform"
  homepage "https://github.com/SagerNet/sing-box"
  version "1.13.19"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.19/sing-box-1.13.19-darwin-arm64.tar.gz"
      sha256 "23bf191906f2dfc9f00e9f0092f274f3426ba9377327e903ff94e636b64d0997"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.19/sing-box-1.13.19-darwin-amd64.tar.gz"
      sha256 "31ee722237d95774e101fbffeae6be6776249c5f7db229ad8ff00b45b22e6a00"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.19/sing-box-1.13.19-linux-arm64.tar.gz"
      sha256 "7fe3597a95a3c5ad67477b1d7653b9ce097e0be7c676758eba1fcf558f353d57"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.19/sing-box-1.13.19-linux-amd64.tar.gz"
      sha256 "ef88a9e577d474210867bd708933d042e9b70106529df2656182c9db90106aa1"
    end
  end

  def install
    bin.install Dir["sing-box*"].first => "sing-box"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sing-box --version 2>&1", 1)
  end
end
