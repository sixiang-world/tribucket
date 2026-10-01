class CorrettoJdk8 < Formula
  desc "Amazon Corretto JDK 8 - no-cost, production-ready OpenJDK"
  homepage "https://aws.amazon.com/corretto/"
  version "8.492.09.2"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-8-aarch64-macos-jdk.tar.gz"
      sha256 "b779a70a47b910ca4c10c5d98d6ae11e2f82d9720423704eaf5eacf87f1ca436"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-8-x64-macos-jdk.tar.gz"
      sha256 "8f8fc4975487ab9cf636c826942fff65cc56b0a91bdc5a2bd91a3d8849e7a3f4"
    end
  end

  on_linux do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-8-aarch64-linux-jdk.tar.gz"
      sha256 "26fe095869f5c700c2c9b8d4b8421d50784d997e2c682aa2226fc47172f9129b"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.tar.gz"
      sha256 "4ce436ddc3258e43b35d0c1f5041913ae5fc14b4f9c5892de5684abc51c858ae"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
