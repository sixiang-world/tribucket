class CorrettoJdk8 < Formula
  desc "Amazon Corretto JDK 8 - no-cost, production-ready OpenJDK"
  homepage "https://aws.amazon.com/corretto/"
  version "8.492.09.2"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-8-aarch64-macos-jdk.tar.gz"
      sha256 "29e7f27d601f202410b4f421155206c1cd52adb0c94513785a70ddc942b251e1"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-8-x64-macos-jdk.tar.gz"
      sha256 "00777f05e91dc20e46b1d23cfeefa8a7728fae57badb07e31cc4ec932dac0cc5"
    end
  end

  on_linux do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-8-aarch64-linux-jdk.tar.gz"
      sha256 "3ac4f2ab91e48a9e8cb4816d11ae5108aaf43b641ffded6ed306c47e44fff8f1"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.tar.gz"
      sha256 "7bc25b00ce9372505168791a56dd6b9452294297502c6ed50137fe2e0700e542"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
