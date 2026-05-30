class TencentKonaJdk11 < Formula
  desc "Tencent Kona JDK 11 - Tencent's distribution of OpenJDK"
  homepage "https://cloud.tencent.com/product/tkjdk"
  version "kona11.0.31"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Tencent/TencentKona-11/releases/download/kona11.0.31/TencentKona-11.0.31.b1-jdk_linux-aarch64.tar.gz"
      sha256 "9f3cf6a5eb28a1b6e02ebc25191c651fb072d2e2566638e8b732230faff7d9a7"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-11/releases/download/kona11.0.31/TencentKona-11.0.31.b1-jdk_linux-aarch64.tar.gz"
      sha256 "9f3cf6a5eb28a1b6e02ebc25191c651fb072d2e2566638e8b732230faff7d9a7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Tencent/TencentKona-11/releases/download/kona11.0.31/TencentKona-11.0.31.b1-jdk_linux-aarch64.tar.gz"
      sha256 "9f3cf6a5eb28a1b6e02ebc25191c651fb072d2e2566638e8b732230faff7d9a7"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-11/releases/download/kona11.0.31/TencentKona-11.0.31.b1-jdk_linux-aarch64.tar.gz"
      sha256 "9f3cf6a5eb28a1b6e02ebc25191c651fb072d2e2566638e8b732230faff7d9a7"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
