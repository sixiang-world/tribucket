class CorrettoJdk21 < Formula
  desc "Amazon Corretto - no-cost, production-ready distribution of OpenJDK"
  homepage "https://aws.amazon.com/corretto/"
  version "21.0.11.10.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-21-aarch64-macos-jdk.tar.gz"
      sha256 "cb230d7ac82784a4438663cdaf91d0d04037a9b4fb99ea41e138d88ce1224ab7"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-21-x64-macos-jdk.tar.gz"
      sha256 "a018ae6221babf065f770479b1bf0ab0d23bea78ed18f236c40bb5d4736612ff"
    end
  end

  on_linux do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-21-aarch64-linux-jdk.tar.gz"
      sha256 "fd94500b0d3d7e6e040a9dc1b34cbe25046454e5e3047b68c1842fa6894e9bbc"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-21-x64-linux-jdk.tar.gz"
      sha256 "75faed442d38a89c27f920e45ab24f9f71ff8ca6b732bfea90cdb500decd3c6b"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
