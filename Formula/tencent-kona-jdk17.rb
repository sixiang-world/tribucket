class TencentKonaJdk17 < Formula
  desc "Tencent Kona JDK 17 - Tencent's distribution of OpenJDK"
  homepage "https://cloud.tencent.com/product/tkjdk"
  version "TencentKona-17.0.20"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Tencent/TencentKona-17/releases/download/TencentKona-17.0.20/TencentKona-17.0.20.b1-jdk_linux-aarch64.tar.gz"
      sha256 "ee54c46fb304762357d9604574f2a76f45654ec349b2e3cdb1e6b84cd1dfacdd"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-17/releases/download/TencentKona-17.0.20/TencentKona-17.0.20.b1-jdk_linux-aarch64.tar.gz"
      sha256 "ee54c46fb304762357d9604574f2a76f45654ec349b2e3cdb1e6b84cd1dfacdd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Tencent/TencentKona-17/releases/download/TencentKona-17.0.20/TencentKona-17.0.20.b1-jdk_linux-aarch64.tar.gz"
      sha256 "ee54c46fb304762357d9604574f2a76f45654ec349b2e3cdb1e6b84cd1dfacdd"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-17/releases/download/TencentKona-17.0.20/TencentKona-17.0.20.b1-jdk_linux-aarch64.tar.gz"
      sha256 "ee54c46fb304762357d9604574f2a76f45654ec349b2e3cdb1e6b84cd1dfacdd"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
