class TemurinJdk11 < Formula
  desc "Eclipse Temurin JDK 11 - OpenJDK binaries by Adoptium"
  homepage "https://adoptium.net"
  version "jdk-11.0.32.1+1"
  license "GPL-2.0"

  on_linux do
    on_arm do
      url "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.32.1%2B1/OpenJDK11U-jdk_aarch64_linux_hotspot_11.0.32.1_1.tar.gz"
      sha256 "f27033e6f7523c1b0b2565a78e9c0e0abe5596a854ce00ca04ec1b06ece7a935"
    end
    on_intel do
      url "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.32.1%2B1/OpenJDK11U-jdk_x64_linux_hotspot_11.0.32.1_1.tar.gz"
      sha256 "5c3f68887c325d36d852ba534303e1f5f1f5cae7d6cc1e951d73e0d8e98a058d"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
