class ZuluJdk17 < Formula
  desc "Azul Zulu JDK 17 - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "17.0.21.0.3"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu17.70.113-ca-jdk17.0.21.0.3-macosx_aarch64.tar.gz"
      sha256 "f4a4d641d4441f480939176208f333aa9403e0a68d27e87245cec98cc994f943"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu17.70.113-ca-jdk17.0.21.0.3-macosx_x64.tar.gz"
      sha256 "6de9a31bd21c09b787781ce90d5791168b522c2213571d742141e610b81ff7fd"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu17.70.113-ca-jdk17.0.21.0.3-linux_aarch64.tar.gz"
      sha256 "8a32c57a101b29fb2e31dd935709517d2a1117d4e696f13ff5035c665ac1d034"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu17.70.113-ca-jdk17.0.21.0.3-linux_x64.tar.gz"
      sha256 "81946095839140100ebff36ff52007676e260bbe482675dbc04772595ed94390"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
