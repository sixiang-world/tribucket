class TencentKonaJdk11 < Formula
  desc "Tencent Kona JDK 11 - Tencent's distribution of OpenJDK"
  homepage "https://cloud.tencent.com/product/tkjdk"
  version "kona11.0.32"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Tencent/TencentKona-11/releases/download/kona11.0.32/TencentKona-11.0.32.b1-jdk_linux-aarch64.tar.gz"
      sha256 "b5f54768b553f9c77b30ada044a737a4aed89f71648962568f63b6474a04baf3"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-11/releases/download/kona11.0.32/TencentKona-11.0.32.b1-jdk_linux-aarch64.tar.gz"
      sha256 "b5f54768b553f9c77b30ada044a737a4aed89f71648962568f63b6474a04baf3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Tencent/TencentKona-11/releases/download/kona11.0.32/TencentKona-11.0.32.b1-jdk_linux-aarch64.tar.gz"
      sha256 "b5f54768b553f9c77b30ada044a737a4aed89f71648962568f63b6474a04baf3"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-11/releases/download/kona11.0.32/TencentKona-11.0.32.b1-jdk_linux-aarch64.tar.gz"
      sha256 "b5f54768b553f9c77b30ada044a737a4aed89f71648962568f63b6474a04baf3"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
