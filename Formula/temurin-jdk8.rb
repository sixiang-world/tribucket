class TemurinJdk8 < Formula
  desc "Eclipse Temurin JDK 8 - OpenJDK binaries by Adoptium"
  homepage "https://adoptium.net"
  version "jdk8u502-b07"
  license "GPL-2.0"

  on_macos do
    on_intel do
      url "https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u502-b07/OpenJDK8U-jdk_x64_mac_hotspot_8u502b07.pkg"
      sha256 "95b897f7aaad33c5097c24bb4cab582f6031dd5e038ffb0902e90d81b0a06ebd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u502-b07/OpenJDK8U-jdk_aarch64_linux_hotspot_8u502b07.tar.gz"
      sha256 "34912db17786f7144dab274f040a42028e25da6e7a6a09780d7013339a56bdb2"
    end
    on_intel do
      url "https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u502-b07/OpenJDK8U-jdk_x64_linux_hotspot_8u502b07.tar.gz"
      sha256 "b8f5440f64f50193c01f67dacba55c9660caffe13b908baf6bd1955f4dd4c3ea"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
