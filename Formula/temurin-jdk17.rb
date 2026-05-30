class TemurinJdk17 < Formula
  desc "Eclipse Temurin JDK 17 - OpenJDK binaries by Adoptium"
  homepage "https://adoptium.net"
  version "jdk-17.0.19+10"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.19%2B10/OpenJDK17U-jdk_aarch64_mac_hotspot_17.0.19_10.pkg"
      sha256 "e709b76af0a28d1a0ebffe042a6c90082ef56343508c57fa4955227d8937f6e4"
    end
    on_intel do
      url "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.19%2B10/OpenJDK17U-jdk_x64_mac_hotspot_17.0.19_10.pkg"
      sha256 "2c0f68b2bde4d4243bfe83f531ac0133a31dbe073301641013cce517af5ef021"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.19%2B10/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.19_10.tar.gz"
      sha256 "83a52172678ec8975164648654869cb2e71d7c748b47aca94b29bbfa10c18e81"
    end
    on_intel do
      url "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.19%2B10/OpenJDK17U-jdk_x64_linux_hotspot_17.0.19_10.tar.gz"
      sha256 "d8afc263758141a66e0e3aafc321e783f7016696f4eaea067d340a269037d331"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
