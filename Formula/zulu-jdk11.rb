class ZuluJdk11 < Formula
  desc "Azul Zulu JDK 11 - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "11.0.32.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu11.90.205-ca-jdk11.0.32.1-macosx_aarch64.tar.gz"
      sha256 "8d08d90f259a43a9b1a672fd6189eb8ee3c6a5e59d95f3cc5efe108e9cd7fd31"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu11.90.205-ca-jdk11.0.32.1-macosx_x64.tar.gz"
      sha256 "a0309d26262328e4716b7cf65b70420444f054208ef769883f3aa245c5d894c2"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu11.90.205-ca-jdk11.0.32.1-linux_aarch64.tar.gz"
      sha256 "4960147b38139ee6bd0c9d3f6c06f1fde71b6603a69618ae8b57a9d66e5dc4a9"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu11.90.205-ca-jdk11.0.32.1-linux_x64.tar.gz"
      sha256 "cb9ca98d2bf067b4cdbd616c21dba1f2c77174ea716d1378fb7fdcb6927223d5"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
