class ZuluJdk11 < Formula
  desc "Azul Zulu JDK 11 - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "11.0.31"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu11.88.17-ca-jdk11.0.31-macosx_aarch64.tar.gz"
      sha256 "fe756215bc360cab0703c9c851f7e46d4762591dff33011420a710d4950e79b1"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu11.88.17-ca-jdk11.0.31-macosx_x64.tar.gz"
      sha256 "fb7382de640ea36b9c246d0e00293b209b53bd3c0f9f958f6dc1b9713f430007"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu11.88.17-ca-jdk11.0.31-linux_aarch64.tar.gz"
      sha256 "8fa22d2c45355b7db381f932f8cda60f959299e2836167d79f0ccb3b1465f0fb"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu11.88.17-ca-jdk11.0.31-linux_x64.tar.gz"
      sha256 "e34761930c630b067d5a449377e71a15281154b1af882dac71f24e2bc3ca93f9"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
