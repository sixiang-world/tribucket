class CorrettoJdk21 < Formula
  desc "Amazon Corretto - no-cost, production-ready distribution of OpenJDK"
  homepage "https://aws.amazon.com/corretto/"
  version "21.0.11.10.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-21-aarch64-macos-jdk.tar.gz"
      sha256 "c6c9ba09ef0ae741aa04cfbd5ef8a6b75dd2d26034a1de0808ee7976a04446ea"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-21-x64-macos-jdk.tar.gz"
      sha256 "fb08b09af67ca930d6868405263259d5e43faab89216f6886780e544fd700f00"
    end
  end

  on_linux do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-21-aarch64-linux-jdk.tar.gz"
      sha256 "bc419602d71d819bce147239fbdc48bfbc900fa1d60693537fb9a22bd6b86475"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-21-x64-linux-jdk.tar.gz"
      sha256 "5b4dc8817df13f88f9bfc434e5d018adb535889ff2fe0ccf758bcebcc216f394"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
