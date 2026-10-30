class TencentKonaJdk17 < Formula
  desc "Tencent Kona JDK 17 - Tencent's distribution of OpenJDK"
  homepage "https://cloud.tencent.com/product/tkjdk"
  version "TencentKona-17.0.21.0.3"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Tencent/TencentKona-17/releases/download/TencentKona-17.0.21.0.3/TencentKona-17.0.21.0.3.b1-jdk_linux-aarch64.tar.gz"
      sha256 "60b7b10a2729faae6edaeb178eede5f4c426e61655a90c1c9aeb597bb3e365ec"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-17/releases/download/TencentKona-17.0.21.0.3/TencentKona-17.0.21.0.3.b1-jdk_linux-aarch64.tar.gz"
      sha256 "60b7b10a2729faae6edaeb178eede5f4c426e61655a90c1c9aeb597bb3e365ec"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Tencent/TencentKona-17/releases/download/TencentKona-17.0.21.0.3/TencentKona-17.0.21.0.3.b1-jdk_linux-aarch64.tar.gz"
      sha256 "60b7b10a2729faae6edaeb178eede5f4c426e61655a90c1c9aeb597bb3e365ec"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-17/releases/download/TencentKona-17.0.21.0.3/TencentKona-17.0.21.0.3.b1-jdk_linux-aarch64.tar.gz"
      sha256 "60b7b10a2729faae6edaeb178eede5f4c426e61655a90c1c9aeb597bb3e365ec"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
