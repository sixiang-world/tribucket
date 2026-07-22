class ZuluJdk21 < Formula
  desc "Azul Zulu - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "21.0.12"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu21.52.15-ca-jdk21.0.12-macosx_aarch64.tar.gz"
      sha256 "84d38c4bf04f73d585bd319b949758d00abde50149a9522c2d9deef46b9a3ec6"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu21.52.15-ca-jdk21.0.12-macosx_x64.tar.gz"
      sha256 "14e05cb1299c27cd26d3c5c6815723f63018df548dc7278c810767607902b4f4"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu21.52.15-ca-jdk21.0.12-linux_aarch64.tar.gz"
      sha256 "dc7ed9ab7dfd33f2ddb1cd8311d3b00738497961a420533d81088051eac3f195"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu21.52.15-ca-jdk21.0.12-linux_x64.tar.gz"
      sha256 "b1a9df12e798770d1b2db43b402a80f1e6080cff6d5d1d1fbe5c768fb4225f6a"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
