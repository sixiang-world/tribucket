class ZuluJdk8 < Formula
  desc "Azul Zulu JDK 8 - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "8.0.512"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu8.98.0.107-ca-jdk8.0.512-macosx_aarch64.tar.gz"
      sha256 "f26e2a91062542cf22ef2171b2556e1c3f42cf87cf174258b3df7840365892aa"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu8.98.0.107-ca-jdk8.0.512-macosx_x64.tar.gz"
      sha256 "1f784fdee4a70970a102262fd34e6da8ab1d9755b3477a2c45906ddd8d290914"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu8.98.0.107-ca-jdk8.0.512-linux_aarch64.tar.gz"
      sha256 "f8ee45a8b0e9c63e16324ea71721dc8bed060ecbf523f9d5ed7fa9f9a447f26c"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu8.98.0.107-ca-jdk8.0.512-linux_x64.tar.gz"
      sha256 "f82a4cb00bbac1ddaa4e578cd6221361a45ee0e4ce51969c4109451750e5164e"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
