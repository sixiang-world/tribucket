class CorrettoJdk21 < Formula
  desc "Amazon Corretto - no-cost, production-ready distribution of OpenJDK"
  homepage "https://aws.amazon.com/corretto/"
  version "21.0.11.10.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-21-aarch64-macos-jdk.tar.gz"
      sha256 "8594556550766865662411ef3a7a71a66df9a9065f28a7b318a5352bda91b6a4"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-21-x64-macos-jdk.tar.gz"
      sha256 "cc9cd6f9b8c34dc3d4df7e5468b810cdfe34ff7517a7d5df0cdbe2b5c22f1cdc"
    end
  end

  on_linux do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-21-aarch64-linux-jdk.tar.gz"
      sha256 "d1206a81145e1ac3f45677f83ecd5e780428848f21f314be33691d62dde761c1"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-21-x64-linux-jdk.tar.gz"
      sha256 "8785082c2fb999c024c8821e4a7c5391bda28f1667cceadafd78e2965b7669d2"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
