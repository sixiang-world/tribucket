class TemurinJdk21 < Formula
  desc "Eclipse Temurin - OpenJDK binaries by Adoptium"
  homepage "https://adoptium.net"
  version "jdk-21.0.12.1+1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.12.1%2B1/OpenJDK21U-jdk_aarch64_mac_hotspot_21.0.12.1_1.pkg"
      sha256 "575bb8d9d604821d8f350325b28a35e49bcffd7ec33727b41edc8d709537dada"
    end
    on_intel do
      url "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.12.1%2B1/OpenJDK21U-jdk_x64_mac_hotspot_21.0.12.1_1.pkg"
      sha256 "9294fd37c0d38d75bf8b0d3e5a74f11c90006dc65b25bf1dd5a3b887e53f5bb9"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
