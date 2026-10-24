class TemurinJdk21 < Formula
  desc "Eclipse Temurin - OpenJDK binaries by Adoptium"
  homepage "https://adoptium.net"
  version "jdk-21.0.13+9"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.13%2B9/OpenJDK21U-jdk_aarch64_mac_hotspot_21.0.13_9.pkg"
      sha256 "7c4cd71ec227fcff5e30d35816c2fe7d82ce2808b9ac6cc7adbd3272af3d9182"
    end
    on_intel do
      url "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.13%2B9/OpenJDK21U-jdk_x64_mac_hotspot_21.0.13_9.pkg"
      sha256 "68d7316cf7afc2cd57b58b9cf4db2e8a709f7f23f8f67d1c782507fe2d9dc79b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.13%2B9/OpenJDK21U-jdk_aarch64_linux_hotspot_21.0.13_9.tar.gz"
      sha256 "e3522e707fc7dbe2a72c30746b1e7068301a0213ecd213d4491f35a14eb55578"
    end
    on_intel do
      url "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.13%2B9/OpenJDK21U-jdk_x64_linux_hotspot_21.0.13_9.tar.gz"
      sha256 "d7f5d5cf865a2902b70ff549b97586a7d3f234e016f041ab447ea740c7d66d1c"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
