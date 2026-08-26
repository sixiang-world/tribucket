class TemurinJdk8 < Formula
  desc "Eclipse Temurin JDK 8 - OpenJDK binaries by Adoptium"
  homepage "https://adoptium.net"
  version "jdk8u504-b01"
  license "GPL-2.0"

  on_macos do
    on_intel do
      url "https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u504-b01/OpenJDK8U-jdk_x64_mac_hotspot_8u504b01.pkg"
      sha256 "899960835a50e67670c8326df4e6160fbe7194201f48871e1a90fd1ca7aad58f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u504-b01/OpenJDK8U-jdk_aarch64_linux_hotspot_8u504b01.tar.gz"
      sha256 "57b7ed8af9d48542bb49ff7894448040b17bea0a48b41677d11ecaec6129768d"
    end
    on_intel do
      url "https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u504-b01/OpenJDK8U-jdk_x64_linux_hotspot_8u504b01.tar.gz"
      sha256 "9c70e102f527ac674ac2fe9c7d47b9a04e2d19842ba5ab8e9b33f368bbadfaea"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
