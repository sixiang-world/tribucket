class ZuluJdk21 < Formula
  desc "Azul Zulu - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "21.0.12.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu21.52.203-ca-jdk21.0.12.1-macosx_aarch64.tar.gz"
      sha256 "042093e0895c940a02d68e727bc37b59f3958e58aa1463ec9080845d77af0a45"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu21.52.203-ca-jdk21.0.12.1-macosx_x64.tar.gz"
      sha256 "6edaf4b72ec6c23d86a46d8b88d0cfed2aaf81645fee13fd852d37af23c4b9fb"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu21.52.203-ca-jdk21.0.12.1-linux_aarch64.tar.gz"
      sha256 "2a8bf9d26eaa10598242d8a4799aff1440a929d6ceacf1c161c28bb1973b003a"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu21.52.203-ca-jdk21.0.12.1-linux_x64.tar.gz"
      sha256 "db0c11e13b545e64d520b4821f4ca38ea9bc1c515924eb1e7f48435df101f183"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
