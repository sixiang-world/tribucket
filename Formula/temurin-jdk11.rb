class TemurinJdk11 < Formula
  desc "Eclipse Temurin JDK 11 - OpenJDK binaries by Adoptium"
  homepage "https://adoptium.net"
  version "jdk-11.0.31+11"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.31%2B11/OpenJDK11U-jdk_aarch64_mac_hotspot_11.0.31_11.pkg"
      sha256 "7ff35af5d5d1c4a2540c4b826b817e06ba3b367cf141eeb7ea3d3b481c6ac42d"
    end
    on_intel do
      url "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.31%2B11/OpenJDK11U-jdk_x64_mac_hotspot_11.0.31_11.pkg"
      sha256 "408d9ab5dcbdd01a05ad942b4edda8be5a6dcc8c7ceeee8bb22fe039b71ba320"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.31%2B11/OpenJDK11U-jdk_aarch64_linux_hotspot_11.0.31_11.tar.gz"
      sha256 "257f4d39e060658fc2eb89a803ca43b3f337e64e253f2d94ebae1d85c9ef5f69"
    end
    on_intel do
      url "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.31%2B11/OpenJDK11U-jdk_x64_linux_hotspot_11.0.31_11.tar.gz"
      sha256 "1e9de64586b519c0a981319489257cabedd9457599f3823424a87c3158fbe939"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
