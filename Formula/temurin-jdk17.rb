class TemurinJdk17 < Formula
  desc "Eclipse Temurin JDK 17 - OpenJDK binaries by Adoptium"
  homepage "https://adoptium.net"
  version "jdk-17.0.20.1+1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.20.1%2B1/OpenJDK17U-jdk_aarch64_mac_hotspot_17.0.20.1_1.pkg"
      sha256 "6e633eb1fc27b03d20360d0f9034e1bd8cc679f0bda1a0588855349a848f7b5d"
    end
    on_intel do
      url "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.20.1%2B1/OpenJDK17U-jdk_x64_mac_hotspot_17.0.20.1_1.pkg"
      sha256 "86faf4db1ea453576db7eb553c22edfce9d1cd559306a9fe1b180b548ccfb500"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.20.1%2B1/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.20.1_1.tar.gz"
      sha256 "457b57af8f9c93ec39080bb8c764f559dc8c89a6da1a39d718a400b7890d3e41"
    end
    on_intel do
      url "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.20.1%2B1/OpenJDK17U-jdk_x64_linux_hotspot_17.0.20.1_1.tar.gz"
      sha256 "3808d1d15e3ec6bd5b84057fb5d84c33d8a1536a258146bcea2e603fc726e08e"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
