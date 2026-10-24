class ZuluJdk21 < Formula
  desc "Azul Zulu - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "21.0.13"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu21.54.107-ca-jdk21.0.13-macosx_aarch64.tar.gz"
      sha256 "7682fcbbc3a164352d36c09c96b2aa91841c8bbafdb9a9a7f5f04db6d290a624"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu21.54.107-ca-jdk21.0.13-macosx_x64.tar.gz"
      sha256 "a6211ef2de128e72519556ea24c7ecb316ec5589b6ed705aef81c889b4233581"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu21.54.107-ca-jdk21.0.13-linux_aarch64.tar.gz"
      sha256 "783460592bc66c9290b14c32a537b29da812bd62ad53bf6cb565355bca7ea563"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu21.54.107-ca-jdk21.0.13-linux_x64.tar.gz"
      sha256 "dd8cf0628cfb8c369b7d4fe96783e2b516482b37d2b3e140b208c91deabf1169"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
