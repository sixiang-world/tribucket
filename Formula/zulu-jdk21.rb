class ZuluJdk21 < Formula
  desc "Azul Zulu - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "21.0.13.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu21.54.201-ca-jdk21.0.13.1-macosx_aarch64.tar.gz"
      sha256 "f6422095eb0d21b6d974cb5af85c121728dfe4bbda0108b1420978e793575adc"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu21.54.201-ca-jdk21.0.13.1-macosx_x64.tar.gz"
      sha256 "1a70bba2c5c1d47752cfffb4149d426009944dee6beceac1bfd6d5c13f89a82f"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu21.54.201-ca-jdk21.0.13.1-linux_aarch64.tar.gz"
      sha256 "7a4683412f5eeee90261ac7eda8d7a96076d794656cb5078d8f0fb38bf2db554"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu21.54.201-ca-jdk21.0.13.1-linux_x64.tar.gz"
      sha256 "510696f7da795e08b48432268173b060a49a6a3b05430690e776b5f3ddecac5e"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
