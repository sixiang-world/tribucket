class ZuluJdk17 < Formula
  desc "Azul Zulu JDK 17 - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "17.0.19"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu17.66.19-ca-jdk17.0.19-macosx_aarch64.tar.gz"
      sha256 "f2bd5afaaaa4c23eb4bf2c78913c7eb7d3d228e44209ffec652fb72388a2f25c"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu17.66.19-ca-jdk17.0.19-macosx_x64.tar.gz"
      sha256 "6a7b8b23f2419ea1dde7eeace0d5a4cc5dbe7bbc83a8dda35dc64aa12269d041"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu17.66.19-ca-jdk17.0.19-linux_aarch64.tar.gz"
      sha256 "c17d5657a673c0cfc099e9d803ed30498495894d7359fd1064d463093ed9850b"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu17.66.19-ca-jdk17.0.19-linux_x64.tar.gz"
      sha256 "ad319aabe659c18fa63fadb446026a7c7f5260f02a6159f51195735d20e7aa1c"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
