class ZuluJdk17 < Formula
  desc "Azul Zulu JDK 17 - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "17.0.21"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu17.70.111-ca-jdk17.0.21-macosx_aarch64.tar.gz"
      sha256 "8e51495d34f4d5a5b023e2e525c65afb3fb139e40507fcbc3dcf949ca13ce550"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu17.70.111-ca-jdk17.0.21-macosx_x64.tar.gz"
      sha256 "2af1c17d9b2ba530328e52946fe3d4864c0670844918a1dbfb644eb2e2e3e08e"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu17.70.111-ca-jdk17.0.21-linux_aarch64.tar.gz"
      sha256 "07389f688d8fe0b77ad754824c09d0be1be19cd4e9f863195d6d545a3c37e988"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu17.70.111-ca-jdk17.0.21-linux_x64.tar.gz"
      sha256 "730ac4f645f601d3005bcdc8736c7e0630d402382e332c11d61ac2494436587f"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
