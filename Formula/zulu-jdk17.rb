class ZuluJdk17 < Formula
  desc "Azul Zulu JDK 17 - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "17.0.21.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu17.70.201-ca-jdk17.0.21.1-macosx_aarch64.tar.gz"
      sha256 "098dbf65069d8e0886aaa7f1fd90adc8d8e41e4b80a1bca8d88e308f3c91f97c"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu17.70.201-ca-jdk17.0.21.1-macosx_x64.tar.gz"
      sha256 "7390536cc1fc2105d26885e0a8f272ebe8e7f975f68dace4c6d0924895cff3ec"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu17.70.201-ca-jdk17.0.21.1-linux_aarch64.tar.gz"
      sha256 "bf8a41fb9d469e6d645cd64d9bd4726a35d496ff821e812c42046e6fe77b4587"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu17.70.201-ca-jdk17.0.21.1-linux_x64.tar.gz"
      sha256 "2837aee74267e02106ee6006809bb0de23ccfa43bf5005621517194b79975695"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
