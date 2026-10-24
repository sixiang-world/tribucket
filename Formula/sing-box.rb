class SingBox < Formula
  desc "The universal proxy platform"
  homepage "https://github.com/SagerNet/sing-box"
  version "1.14.4"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.14.4/sing-box-1.14.4-darwin-arm64.tar.gz"
      sha256 "0d8c7f5ed5d587b0f1a5e9772a708ec3bfa4ac4c9329604b01d8d9c2ba406838"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.14.4/sing-box-1.14.4-darwin-amd64.tar.gz"
      sha256 "eae86b9b033bba50b7c44ab719e4bfac0aca05efd28483390ed3aa510f32db25"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.14.4/sing-box-1.14.4-linux-arm64.tar.gz"
      sha256 "436441f76ee2f7fe21b5b2d426d3cb261a480455a704865789ad533e4273ec26"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.14.4/sing-box-1.14.4-linux-amd64.tar.gz"
      sha256 "699a1b510aa4396b2176d32d1181920399ebf1e267835da6f3b598d0f7c24968"
    end
  end

  def install
    bin.install Dir["sing-box*"].first => "sing-box"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sing-box --version 2>&1", 1)
  end
end
