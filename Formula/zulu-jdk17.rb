class ZuluJdk17 < Formula
  desc "Azul Zulu JDK 17 - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "17.0.20"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu17.68.17-ca-jdk17.0.20-macosx_aarch64.tar.gz"
      sha256 "0da52534760b74ba8a42660384b2f4e44311a47ae52faa45fcbd829b2797b244"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu17.68.17-ca-jdk17.0.20-macosx_x64.tar.gz"
      sha256 "b5bace4a346a7af0fe4f50904c46770e66d4b465800b038693c35e5d5b9bd52a"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu17.68.17-ca-jdk17.0.20-linux_aarch64.tar.gz"
      sha256 "46f1dc7678760d37d38699c5a5a34dea8ed451dcdf6d27890a7b61f025e7ff60"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu17.68.17-ca-jdk17.0.20-linux_x64.tar.gz"
      sha256 "32c5efedf69f4a95635ea2923f6a6ee90ce6ca83df0bd43ba55dd662d5af429a"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
