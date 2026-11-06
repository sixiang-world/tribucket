class TemurinJdk11 < Formula
  desc "Eclipse Temurin JDK 11 - OpenJDK binaries by Adoptium"
  homepage "https://adoptium.net"
  version "jdk-11.0.33+10"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.33%2B10/OpenJDK11U-jdk_aarch64_mac_hotspot_11.0.33_10.pkg"
      sha256 "94ca9f6b7536309890b724108d3817ec1f648215c164433794776ed0fb02b774"
    end
    on_intel do
      url "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.33%2B10/OpenJDK11U-jdk_x64_mac_hotspot_11.0.33_10.pkg"
      sha256 "bf22c47b19698703d2da0f564219edfc50fd1b303d66a340f0a87344bfff943f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.33%2B10/OpenJDK11U-jdk_aarch64_linux_hotspot_11.0.33_10.tar.gz"
      sha256 "60b0fb79bb678b6fae3e499c7b0a353e68633ed0ab69d1a6bafe6092ed1e59e4"
    end
    on_intel do
      url "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.33%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.33_10.tar.gz"
      sha256 "c4b8eaf56c93b95b689ffc08d155df1bcdbbffb666f8f71d21d97aedaea6f0ec"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
