class CorrettoJdk17 < Formula
  desc "Amazon Corretto JDK 17 - no-cost, production-ready OpenJDK"
  homepage "https://aws.amazon.com/corretto/"
  version "17.0.19.10.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-17-aarch64-macos-jdk.tar.gz"
      sha256 "3ba2ab957f60e33c6164d7330b1f6c9f48b5ffd60e4cc9bbcc67def319c29a29"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-17-x64-macos-jdk.tar.gz"
      sha256 "6d3b3e367e1a77b9867bc1b5aa925b1f05d76a0ec62b075e375fa91fdcea0e93"
    end
  end

  on_linux do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-17-aarch64-linux-jdk.tar.gz"
      sha256 "1b9f75b5a2f740ab3305577858e2fc87dad827b60678d4573234d6357be59fa8"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.tar.gz"
      sha256 "d0f1b880445691425511c3aa62cb89889f03a71c2a43597a3df174fc01d3f3a0"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
