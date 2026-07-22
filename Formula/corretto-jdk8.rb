class CorrettoJdk8 < Formula
  desc "Amazon Corretto JDK 8 - no-cost, production-ready OpenJDK"
  homepage "https://aws.amazon.com/corretto/"
  version "8.492.09.2"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-8-aarch64-macos-jdk.tar.gz"
      sha256 "81a172ff2dfb3f408eca5b0a0dfaf84657cb68f9a0cc94818d562e144b3f199f"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-8-x64-macos-jdk.tar.gz"
      sha256 "ab6c714f54388f67bce204cea9f40b2a5ea8fed3263e425520efbc970e6c1f6f"
    end
  end

  on_linux do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-8-aarch64-linux-jdk.tar.gz"
      sha256 "7aafc6a9e4c284cbe9753ffe1af5495ca12370f6ac9f02e7ab1d81ef2f1d4c50"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.tar.gz"
      sha256 "ff9b634a2a70b81b75e855be1db50ff712e4ea5f92dc224cb1c069122710b111"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
