class ZuluJdk11 < Formula
  desc "Azul Zulu JDK 11 - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "11.0.33.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu11.92.201-ca-jdk11.0.33.1-macosx_aarch64.tar.gz"
      sha256 "86c26aecc85bb83245a7d837543342d1635733f5c5d44c1ae274f0ac7c2fccaf"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu11.92.201-ca-jdk11.0.33.1-macosx_x64.tar.gz"
      sha256 "3266ce5ba9e3a275134238621c1482ba785f897e1f379dca0266bcbaeae6c72a"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu11.92.201-ca-jdk11.0.33.1-linux_aarch64.tar.gz"
      sha256 "b348c48a53d9f96f0968a20d8c4d65a29a23c36c16461622aa3e18f6db8df772"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu11.92.201-ca-jdk11.0.33.1-linux_x64.tar.gz"
      sha256 "9394707fa2ede9929cee172bc0ac5b7cfe9f6af35e5768bf974515a3faa39c67"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
