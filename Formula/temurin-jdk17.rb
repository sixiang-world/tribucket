class TemurinJdk17 < Formula
  desc "Eclipse Temurin JDK 17 - OpenJDK binaries by Adoptium"
  homepage "https://adoptium.net"
  version "jdk-17.0.21+9"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.21%2B9/OpenJDK17U-jdk_aarch64_mac_hotspot_17.0.21_9.pkg"
      sha256 "ab0bd83d1af973b8c4846b3939a1cbd71474fb07cf817074e1f9e8e40e97eb29"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.21%2B9/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.21_9.tar.gz"
      sha256 "3e4eca7ead088f080af1476007decf010a240a1eb4e1e78c54fa32fbcc347084"
    end
    on_intel do
      url "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.21%2B9/OpenJDK17U-jdk_x64_linux_hotspot_17.0.21_9.tar.gz"
      sha256 "8b9b611d917e3dfd8419d3566b5949226f69b052fed7e109c1368add1dfe8711"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
