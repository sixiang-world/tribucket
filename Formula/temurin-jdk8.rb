class TemurinJdk8 < Formula
  desc "Eclipse Temurin JDK 8 - OpenJDK binaries by Adoptium"
  homepage "https://adoptium.net"
  version "jdk8u512-b09"
  license "GPL-2.0"

  on_linux do
    on_arm do
      url "https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u512-b09/OpenJDK8U-jdk_aarch64_linux_hotspot_8u512b09.tar.gz"
      sha256 "01263df22c4553f63146bbae807e70cd4628dd0d9ec7582f01cb2453f7c69aaa"
    end
    on_intel do
      url "https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u512-b09/OpenJDK8U-jdk_x64_linux_hotspot_8u512b09.tar.gz"
      sha256 "fb3bfa869012419b562bb4235d0d83ec4f8c1dda62ae432ba20c6c3a7e43f7e4"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
