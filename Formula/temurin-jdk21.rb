class TemurinJdk21 < Formula
  desc "Eclipse Temurin - OpenJDK binaries by Adoptium"
  homepage "https://adoptium.net"
  version "jdk-21.0.11+10"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.11%2B10/OpenJDK21U-jdk_aarch64_mac_hotspot_21.0.11_10.pkg"
      sha256 "1c1721d5df6c2ab2edd8d2801bac07a8895b051e51b1946b1897d0a712138115"
    end
    on_intel do
      url "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.11%2B10/OpenJDK21U-jdk_x64_mac_hotspot_21.0.11_10.pkg"
      sha256 "a814d873a80386f3d2eeca6b8408efcad8d824e61ffa1c2dcb38c95dbb6918e1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.11%2B10/OpenJDK21U-jdk_aarch64_linux_hotspot_21.0.11_10.tar.gz"
      sha256 "8d498ec88e1c1989fab95c6784240ab92d011e29c54d20a3f9c324b13476f9ad"
    end
    on_intel do
      url "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.11%2B10/OpenJDK21U-jdk_x64_linux_hotspot_21.0.11_10.tar.gz"
      sha256 "4b2220e232a97997b436ca6ab15cbf70171ecff52958a46159dfa5a8c44ca4de"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
