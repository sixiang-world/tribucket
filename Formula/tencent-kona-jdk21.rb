class TencentKonaJdk21 < Formula
  desc "Tencent Kona - Tencent's distribution of OpenJDK"
  homepage "https://cloud.tencent.com/product/tkjdk"
  version "TencentKona-21.0.11"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Tencent/TencentKona-21/releases/download/TencentKona-21.0.11/TencentKona-21.0.11.b1_jdk_macosx-aarch64_notarized.tar.gz"
      sha256 "9914e81e33811f50bd23aebd8115f9c1c70944950b62fca4e65bee73e6544eb6"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-21/releases/download/TencentKona-21.0.11/TencentKona-21.0.11.b1_jdk_macosx-x86_64_notarized.tar.gz"
      sha256 "eda1ba746a8deb872b6d203346429c08dd1604c71215bd8ae769aa724c717c91"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Tencent/TencentKona-21/releases/download/TencentKona-21.0.11/TencentKona-21.0.11.b1-jdk_linux-aarch64.tar.gz"
      sha256 "c3bc896aa66bd3883da383e9ede2a9e66cf3897674548b7a942056424b63c3b0"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-21/releases/download/TencentKona-21.0.11/TencentKona-21.0.11.b1-jdk_linux-x86_64.tar.gz"
      sha256 "96f71aabef907853673f8d79189570d28eb668aea41904f40905f4b7e0619f51"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
