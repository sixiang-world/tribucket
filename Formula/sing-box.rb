class SingBox < Formula
  desc "The universal proxy platform"
  homepage "https://github.com/SagerNet/sing-box"
  version "1.14.3"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.14.3/sing-box-1.14.3-darwin-arm64.tar.gz"
      sha256 "0360ce634a04c26a6b4fd957517987bb4f6c8950f63435ce3c5af2fcae5860c5"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.14.3/sing-box-1.14.3-darwin-amd64.tar.gz"
      sha256 "6d002b74d03b478547349cc10af89e007868596e5aa931816d45da9f544715a9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.14.3/sing-box-1.14.3-linux-arm64.tar.gz"
      sha256 "29dae24d76bea3bc62d07dd3e60cfc12003de7debbd6b768df9be9c68360174e"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.14.3/sing-box-1.14.3-linux-amd64.tar.gz"
      sha256 "e2bdf179c15a3652955dc44867e33ca0965c9c9b91b34267dcc5a5d639a5feee"
    end
  end

  def install
    bin.install Dir["sing-box*"].first => "sing-box"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sing-box --version 2>&1", 1)
  end
end
