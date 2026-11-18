class ZuluJdk8 < Formula
  desc "Azul Zulu JDK 8 - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "8.0.514"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu8.98.0.201-ca-jdk8.0.514-macosx_aarch64.tar.gz"
      sha256 "792935f732653f5c4fd4cdc68e3ade65cb1fa1fda6b6769fc5dd8098b330b298"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu8.98.0.201-ca-jdk8.0.514-macosx_x64.tar.gz"
      sha256 "49fc194f8ed1c7d1757ede4d7055f32afa4544b613e3b595d38441419002f759"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu8.98.0.201-ca-jdk8.0.514-linux_aarch64.tar.gz"
      sha256 "2a8b15fcccadfc7b5c2904f078ef2de56aeb76aae661b95ab527ffeadf0cd592"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu8.98.0.201-ca-jdk8.0.514-linux_x64.tar.gz"
      sha256 "16a4c55c3061ee41e94edb109f5aea1c55a2952d37e25e215d478b8347350860"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
