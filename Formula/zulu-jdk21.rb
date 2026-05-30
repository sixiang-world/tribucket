class ZuluJdk21 < Formula
  desc "Azul Zulu - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "21.0.11"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu21.50.19-ca-jdk21.0.11-macosx_aarch64.tar.gz"
      sha256 "59cf896951a1f3cd132abfc1f74ba4db1f916ecc81b3c0022c5c16a21ae940ad"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu21.50.19-ca-jdk21.0.11-macosx_x64.tar.gz"
      sha256 "906990cbe599731e3c8ec85f7a6f2e72d4a0f9ec1cc18b6b52a16e1e2fc5934d"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu21.50.19-ca-jdk21.0.11-linux_aarch64.tar.gz"
      sha256 "cd4be5eaed50d2b81485dfe260e2fab7e2c90a854bf11b7bfb4eeb6936757c4a"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu21.50.19-ca-jdk21.0.11-linux_x64.tar.gz"
      sha256 "bc5e3383431cb7f1dce8c262dd474501ee9bd7569f1c59a8b6fe5c1589aa4a58"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
