class CorrettoJdk11 < Formula
  desc "Amazon Corretto JDK 11 - no-cost, production-ready OpenJDK"
  homepage "https://aws.amazon.com/corretto/"
  version "11.0.31.11.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-11-aarch64-macos-jdk.tar.gz"
      sha256 "94dfe3dce2a508a5e0e3c67c75feb2ad580531c0dfd66ef46db17e0a8b08a338"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-11-x64-macos-jdk.tar.gz"
      sha256 "96a4ffe772ffc62bdc7892720ff23935b6b888d8b05273dadf191f2e0410bd04"
    end
  end

  on_linux do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-11-aarch64-linux-jdk.tar.gz"
      sha256 "ada21539d4959e8946b20b55a2c868a006d4b993be0633c576e3d38c8b9d0c1c"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.tar.gz"
      sha256 "f368ac379f3b20e266080e80fcc1f5e8567d044a4f895c8786220cab5b580c15"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
