class TemurinJdk8 < Formula
  desc "Eclipse Temurin JDK 8 - OpenJDK binaries by Adoptium"
  homepage "https://adoptium.net"
  version "jdk8u504-b01"
  license "GPL-2.0"

  on_linux do
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
