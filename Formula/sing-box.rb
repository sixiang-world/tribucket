class SingBox < Formula
  desc "The universal proxy platform"
  homepage "https://github.com/SagerNet/sing-box"
  version "1.14.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.14.1/sing-box-1.14.1-darwin-arm64.tar.gz"
      sha256 "b9024642ef7b4848252df5469b7f60ef3c18bb5e217a16a0934f0174f8ad11b4"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.14.1/sing-box-1.14.1-darwin-amd64.tar.gz"
      sha256 "b34381b047106fe84895df14f7aaae06f3182130b728006944deb0d59d8590c3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.14.1/sing-box-1.14.1-linux-arm64.tar.gz"
      sha256 "6060b42fa84c5dcaeae1799af7f61b0f1ae4855d9d5ddc9e02baba17154b3ae2"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.14.1/sing-box-1.14.1-linux-amd64.tar.gz"
      sha256 "12cb2816b52febb356f6a885b740cc8758c3f30b8ae0ca8edba80f0d2d35343f"
    end
  end

  def install
    bin.install Dir["sing-box*"].first => "sing-box"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sing-box --version 2>&1", 1)
  end
end
