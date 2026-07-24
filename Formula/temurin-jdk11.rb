class TemurinJdk11 < Formula
  desc "Eclipse Temurin JDK 11 - OpenJDK binaries by Adoptium"
  homepage "https://adoptium.net"
  version "jdk-11.0.32+9"
  license "GPL-2.0"

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
