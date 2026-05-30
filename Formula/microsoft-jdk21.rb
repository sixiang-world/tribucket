class MicrosoftJdk21 < Formula
  desc "Microsoft Build of OpenJDK"
  homepage "https://learn.microsoft.com/java/openjdk/overview"
  version "21.0.6"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://aka.ms/download-jdk/microsoft-jdk-21.0.6-macos-aarch64.tar.gz"
      sha256 "c277969b6b9021179e1e356d03e91f59333699e776ede58b66c99fb39fec6c43"
    end
    on_intel do
      url "https://aka.ms/download-jdk/microsoft-jdk-21.0.6-macos-x64.tar.gz"
      sha256 "72a4be9114ff8fb1830aeccd9dc2cde5eaad685aef9b3869f5d8a1dc9ce40eee"
    end
  end

  on_linux do
    on_arm do
      url "https://aka.ms/download-jdk/microsoft-jdk-21.0.6-linux-aarch64.tar.gz"
      sha256 "136096968e2ae1c937d26be2436e829ec6375a744e96caffb442a758fafae92d"
    end
    on_intel do
      url "https://aka.ms/download-jdk/microsoft-jdk-21.0.6-linux-x64.tar.gz"
      sha256 "701b98a494a220ee5ff144f507b1c820726d9fac4e4a1ac5f30b1ab91deb2a3a"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
