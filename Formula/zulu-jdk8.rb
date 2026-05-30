class ZuluJdk8 < Formula
  desc "Azul Zulu JDK 8 - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "8.0.492"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu8.94.0.17-ca-jdk8.0.492-macosx_aarch64.tar.gz"
      sha256 "73b84abff0ca4a1b648b6cd12381194496bcf31ee01f2bdd1ed0914c9ee5a159"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu8.94.0.17-ca-jdk8.0.492-macosx_x64.tar.gz"
      sha256 "5114b269b88e3d89b0d6b2c28af0c96b5489f340fbaded8fa17613b2adca180c"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu8.94.0.17-ca-jdk8.0.492-linux_aarch64.tar.gz"
      sha256 "24f5e8183a52efb5abcee2b8173b0887089ba7476f11bc15603464353cc4e4a8"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu8.94.0.17-ca-jdk8.0.492-linux_x64.tar.gz"
      sha256 "a6d14104f2e7186cba8943c4dc182938db91509dc2c0ef9ecee046c864624d36"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
