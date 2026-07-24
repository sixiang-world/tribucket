class TemurinJdk17 < Formula
  desc "Eclipse Temurin JDK 17 - OpenJDK binaries by Adoptium"
  homepage "https://adoptium.net"
  version "jdk-17.0.20+8"
  license "GPL-2.0"

  on_macos do
    on_intel do
      url "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.20%2B8/OpenJDK17U-jdk_x64_mac_hotspot_17.0.20_8.pkg"
      sha256 "d074b50af1b3674942b48a4939fc854c577bf8e96a2be0f1102fca573cce2f8a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.20%2B8/OpenJDK17U-jdk_x64_linux_hotspot_17.0.20_8.tar.gz"
      sha256 "be7668bc030d578b83d6d5ef9221d6d6729bbbca8cf94a7d52e16ac68b5a5a35"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
