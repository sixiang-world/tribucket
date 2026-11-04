class TencentKonaJdk11 < Formula
  desc "Tencent Kona JDK 11 - Tencent's distribution of OpenJDK"
  homepage "https://cloud.tencent.com/product/tkjdk"
  version "kona11.0.33"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Tencent/TencentKona-11/releases/download/kona11.0.33/TencentKona-11.0.33.b1-jdk_linux-x86_64.tar.gz"
      sha256 "0d91137f1fc125d882256e6858dfd4dd5a2159147f22fccc1a9875dc8d6deb69"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-11/releases/download/kona11.0.33/TencentKona-11.0.33.b1-jdk_linux-x86_64.tar.gz"
      sha256 "0d91137f1fc125d882256e6858dfd4dd5a2159147f22fccc1a9875dc8d6deb69"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Tencent/TencentKona-11/releases/download/kona11.0.33/TencentKona-11.0.33.b1-jdk_linux-x86_64.tar.gz"
      sha256 "0d91137f1fc125d882256e6858dfd4dd5a2159147f22fccc1a9875dc8d6deb69"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-11/releases/download/kona11.0.33/TencentKona-11.0.33.b1-jdk_linux-x86_64.tar.gz"
      sha256 "0d91137f1fc125d882256e6858dfd4dd5a2159147f22fccc1a9875dc8d6deb69"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
