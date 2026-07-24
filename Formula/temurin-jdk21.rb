class TemurinJdk21 < Formula
  desc "Eclipse Temurin - OpenJDK binaries by Adoptium"
  homepage "https://adoptium.net"
  version "jdk-21.0.12+8"
  license "GPL-2.0"

  on_linux do
    on_arm do
      url "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.12%2B8/OpenJDK21U-jdk_aarch64_linux_hotspot_21.0.12_8.tar.gz"
      sha256 "eba38e871b02d407897bfe017ea35352dfc1420ef6d2112425b0c67325ca509d"
    end
    on_intel do
      url "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.12%2B8/OpenJDK21U-jdk_x64_linux_hotspot_21.0.12_8.tar.gz"
      sha256 "e4446ff06a276155697597cc0f1b15da004ff083f4964a35271ecee567177370"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
