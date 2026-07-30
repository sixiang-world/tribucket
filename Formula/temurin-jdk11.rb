class TemurinJdk11 < Formula
  desc "Eclipse Temurin JDK 11 - OpenJDK binaries by Adoptium"
  homepage "https://adoptium.net"
  version "jdk-11.0.32+9"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.32%2B9/OpenJDK11U-jdk_aarch64_mac_hotspot_11.0.32_9.pkg"
      sha256 "4d40fb153a4d962b7f2bdab5839d1bb6d53b797419cc68691585cfd48e646c2b"
    end
    on_intel do
      url "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.32%2B9/OpenJDK11U-jdk_x64_mac_hotspot_11.0.32_9.pkg"
      sha256 "02d722c7e90e79dd42e54f005de04386176e2f5632d5ed708e5326a9d3214fcd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.32%2B9/OpenJDK11U-jdk_aarch64_linux_hotspot_11.0.32_9.tar.gz"
      sha256 "66a7d4af3572d920b0f1b01710ffa79888d4ddd1b784632e33a3d711aa7d1e63"
    end
    on_intel do
      url "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.32%2B9/OpenJDK11U-jdk_x64_linux_hotspot_11.0.32_9.tar.gz"
      sha256 "5906e0339e9322a688b2375eaf40666e00a16e008b0067b0a9f9e4b6c5033720"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
