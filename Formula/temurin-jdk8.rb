class TemurinJdk8 < Formula
  desc "Eclipse Temurin JDK 8 - OpenJDK binaries by Adoptium"
  homepage "https://adoptium.net"
  version "jdk8u492-b09"
  license "GPL-2.0"

  on_macos do
    on_intel do
      url "https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u492-b09/OpenJDK8U-jdk_x64_mac_hotspot_8u492b09.pkg"
      sha256 "8d70d1bdc7a8666ed550e5db3c2e4acc5f67f3d16dadf47ce46d352d6d54dc18"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u492-b09/OpenJDK8U-jdk_aarch64_linux_hotspot_8u492b09.tar.gz"
      sha256 "3c2253b986909c20f79d6de7a0cb957f89c243df57615897836046e24d2e5257"
    end
    on_intel do
      url "https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u492-b09/OpenJDK8U-jdk_x64_linux_hotspot_8u492b09.tar.gz"
      sha256 "da257f161d7f8c6ca5b0e5d9e4090f65ac28c5e398072e68b8ae87988b1d1a2e"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
