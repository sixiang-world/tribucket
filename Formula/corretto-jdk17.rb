class CorrettoJdk17 < Formula
  desc "Amazon Corretto JDK 17 - no-cost, production-ready OpenJDK"
  homepage "https://aws.amazon.com/corretto/"
  version "17.0.19.10.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-17-aarch64-macos-jdk.tar.gz"
      sha256 "44e16fd802661560640fc04209f72a61816bae3b02aae9fa7668ee23228b22f6"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-17-x64-macos-jdk.tar.gz"
      sha256 "3e328eaf6e82c5a95afc5bdfa8b65b387e18836f57e95bde31c0ad476678edf9"
    end
  end

  on_linux do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-17-aarch64-linux-jdk.tar.gz"
      sha256 "aca6cc93156f741995b81d91f2d7085992028b2c40056b5a405e6c7d9e350198"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.tar.gz"
      sha256 "74ff458657da91ca222681993e3c6b9a8e3629ca8e61c0d8cd90527280da9aa5"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
