class TencentKonaJdk17 < Formula
  desc "Tencent Kona JDK 17 - Tencent's distribution of OpenJDK"
  homepage "https://cloud.tencent.com/product/tkjdk"
  version "TencentKona-17.0.19"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Tencent/TencentKona-17/releases/download/TencentKona-17.0.19/TencentKona-17.0.19.b1-jdk_linux-aarch64.tar.gz"
      sha256 "639303ec313f6624b936c9ba59a23c226c60ec40463406e1dc491a41ae323d84"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-17/releases/download/TencentKona-17.0.19/TencentKona-17.0.19.b1-jdk_linux-aarch64.tar.gz"
      sha256 "639303ec313f6624b936c9ba59a23c226c60ec40463406e1dc491a41ae323d84"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Tencent/TencentKona-17/releases/download/TencentKona-17.0.19/TencentKona-17.0.19.b1-jdk_linux-aarch64.tar.gz"
      sha256 "639303ec313f6624b936c9ba59a23c226c60ec40463406e1dc491a41ae323d84"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-17/releases/download/TencentKona-17.0.19/TencentKona-17.0.19.b1-jdk_linux-aarch64.tar.gz"
      sha256 "639303ec313f6624b936c9ba59a23c226c60ec40463406e1dc491a41ae323d84"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
