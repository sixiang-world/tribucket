class ZuluJdk17 < Formula
  desc "Azul Zulu JDK 17 - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "17.0.20.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu17.68.203-ca-jdk17.0.20.1-macosx_aarch64.tar.gz"
      sha256 "ed54397260c5994b2fc4e31c780f480b947e6532bc6a5ac7754355d5dd4c127d"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu17.68.203-ca-jdk17.0.20.1-macosx_x64.tar.gz"
      sha256 "ec1f9c98a9c1304230af23c565a3592c48314409e82ead75e3a98ee4fc94336f"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu17.68.203-ca-jdk17.0.20.1-linux_aarch64.tar.gz"
      sha256 "aa10cb26f73fb1b50dcd72a51851f7eedaf75cb5c18760e521884f96c98defd2"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu17.68.203-ca-jdk17.0.20.1-linux_x64.tar.gz"
      sha256 "4ef843383724c7cee278b90aabe41c9ae172a3b2584ab0e086857bb536ef060f"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
