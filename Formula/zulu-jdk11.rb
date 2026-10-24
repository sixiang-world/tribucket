class ZuluJdk11 < Formula
  desc "Azul Zulu JDK 11 - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "11.0.33"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu11.92.109-ca-jdk11.0.33-macosx_aarch64.tar.gz"
      sha256 "4947b01fcb220ee69710dbf63375f4628688d84750fccd289f5a6d62b494aa94"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu11.92.109-ca-jdk11.0.33-macosx_x64.tar.gz"
      sha256 "ae69ef573c3ad76294f079026775b3b5c70a5fa94fd2f4fccacfaf4b80ed7c13"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu11.92.109-ca-jdk11.0.33-linux_aarch64.tar.gz"
      sha256 "abed984a694d4da40662ec0bdfd2ecbe798bab1b8ce784d4f02d00479d53e802"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu11.92.109-ca-jdk11.0.33-linux_x64.tar.gz"
      sha256 "64658a2be5140c2ffd571c0e09ac3b505a2be0d4654e09957b584b54b4dac8b5"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
