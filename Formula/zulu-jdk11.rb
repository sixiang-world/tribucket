class ZuluJdk11 < Formula
  desc "Azul Zulu JDK 11 - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "11.0.32"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu11.90.19-ca-jdk11.0.32-macosx_aarch64.tar.gz"
      sha256 "a552338385fa27026ced01a3c56a3b3a2de048ed4b79907d876e99be80547551"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu11.90.19-ca-jdk11.0.32-macosx_x64.tar.gz"
      sha256 "5ba1b39cc08999645944bcfd54da48dd6c9a0891785d56cff95e92324fa841f6"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu11.90.19-ca-jdk11.0.32-linux_aarch64.tar.gz"
      sha256 "31fb32a1c9d842f96e8e79c683996e217d087b3aeac0cc6bfc39f028eb860146"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu11.90.19-ca-jdk11.0.32-linux_x64.tar.gz"
      sha256 "d4832d97886444346ed75fd1059c68c5e38795098e3273e4a0929fe2eb2abf76"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
