class CorrettoJdk21 < Formula
  desc "Amazon Corretto - no-cost, production-ready distribution of OpenJDK"
  homepage "https://aws.amazon.com/corretto/"
  version "21.0.11.10.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-21-aarch64-macos-jdk.tar.gz"
      sha256 "f4ee9236ffc3ddcd37da877e04a1ab74b3d3376cf9e4287b5426f4749cc869a9"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-21-x64-macos-jdk.tar.gz"
      sha256 "12cf7651ba1f2fd04357d5277b0d58a78a7df5d672bc7cfc085ccb0d60c4bc8c"
    end
  end

  on_linux do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-21-aarch64-linux-jdk.tar.gz"
      sha256 "0985275871a6e064324f46f52c5cd89d45013c830e10a41539f6fd7f450808e9"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-21-x64-linux-jdk.tar.gz"
      sha256 "f3330bf440b8f4514b7b279b6145d4b4493dea9dda5f3a702b49c53c41bec1e4"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
