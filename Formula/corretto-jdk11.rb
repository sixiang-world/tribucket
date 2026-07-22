class CorrettoJdk11 < Formula
  desc "Amazon Corretto JDK 11 - no-cost, production-ready OpenJDK"
  homepage "https://aws.amazon.com/corretto/"
  version "11.0.31.11.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-11-aarch64-macos-jdk.tar.gz"
      sha256 "569ef802134a63d026b9a0215c2c61e49a077ce896462334b63668cdd644b1f6"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-11-x64-macos-jdk.tar.gz"
      sha256 "399ff66c80c4f55024c8ba36bfdefbcd4ac180934d147a30b9f66d6970b055e7"
    end
  end

  on_linux do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-11-aarch64-linux-jdk.tar.gz"
      sha256 "c922bdb3b9ee3eb2e5c6c15f39147d79f4698cd17e181423fea46319b3891504"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.tar.gz"
      sha256 "b09aac76316cef26dca770c89ca23ce55708bd0463e2640e86915ee528cb5bd0"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
