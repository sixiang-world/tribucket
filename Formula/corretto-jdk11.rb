class CorrettoJdk11 < Formula
  desc "Amazon Corretto JDK 11 - no-cost, production-ready OpenJDK"
  homepage "https://aws.amazon.com/corretto/"
  version "11.0.31.11.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-11-aarch64-macos-jdk.tar.gz"
      sha256 "4aa39d366c886629fb58dead41843d21a2f77d48bfbb6c397970fc819f78ad75"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-11-x64-macos-jdk.tar.gz"
      sha256 "1c6991cf895d1b12aa741f7e4b75bb9e5455d1bf654144237fa7108b7f15dd3a"
    end
  end

  on_linux do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-11-aarch64-linux-jdk.tar.gz"
      sha256 "39c0714b80282445b7ab5864389907463531c720a89f0684d919a0221e068193"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.tar.gz"
      sha256 "826ab4fb0669a8afc25a927264017ba71a62b1f9e701a7b7e1ea6090866c0668"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
