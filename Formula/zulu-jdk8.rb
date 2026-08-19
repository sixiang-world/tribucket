class ZuluJdk8 < Formula
  desc "Azul Zulu JDK 8 - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "8.0.504"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu8.96.0.205-ca-jdk8.0.504-macosx_aarch64.tar.gz"
      sha256 "58bb3c08f2aa63d9743cf31899fa4b8c6c9effefce9479e7288c26621c3bb21b"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu8.96.0.205-ca-jdk8.0.504-macosx_x64.tar.gz"
      sha256 "e35bc8a4401193aa670146762bbad132bf0651fee5e3f16acbb3a5db0e0b0cff"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu8.96.0.205-ca-jdk8.0.504-linux_aarch64.tar.gz"
      sha256 "c79f5fd740702a1336a9e6da2262be03e1a6e4255a94d198b66c49896be6b478"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu8.96.0.205-ca-jdk8.0.504-linux_x64.tar.gz"
      sha256 "fdb93d3789f740c62b85c57a1c55db9960eb8bf6d7966ca8becd2a6be89bfcbf"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
