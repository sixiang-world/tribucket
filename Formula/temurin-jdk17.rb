class TemurinJdk17 < Formula
  desc "Eclipse Temurin JDK 17 - OpenJDK binaries by Adoptium"
  homepage "https://adoptium.net"
  version "jdk-17.0.20.1+1"
  license "GPL-2.0"

  on_macos do
    on_intel do
      url "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.20.1%2B1/OpenJDK17U-jdk_x64_mac_hotspot_17.0.20.1_1.pkg"
      sha256 "86faf4db1ea453576db7eb553c22edfce9d1cd559306a9fe1b180b548ccfb500"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
