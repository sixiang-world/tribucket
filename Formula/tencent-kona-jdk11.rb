class TencentKonaJdk11 < Formula
  desc "Tencent Kona JDK 11 - Tencent's distribution of OpenJDK"
  homepage "https://cloud.tencent.com/product/tkjdk"
  version "kona11.0.33.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Tencent/TencentKona-11/releases/download/kona11.0.33.1/TencentKona-11.0.33.1.b1-jdk_linux-aarch64.tar.gz"
      sha256 "db287b215c01fcfe6eca89c1bc1e82caf667552f6408c5f4534a93341e24313a"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-11/releases/download/kona11.0.33.1/TencentKona-11.0.33.1.b1-jdk_linux-aarch64.tar.gz"
      sha256 "db287b215c01fcfe6eca89c1bc1e82caf667552f6408c5f4534a93341e24313a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Tencent/TencentKona-11/releases/download/kona11.0.33.1/TencentKona-11.0.33.1.b1-jdk_linux-aarch64.tar.gz"
      sha256 "db287b215c01fcfe6eca89c1bc1e82caf667552f6408c5f4534a93341e24313a"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-11/releases/download/kona11.0.33.1/TencentKona-11.0.33.1.b1-jdk_linux-aarch64.tar.gz"
      sha256 "db287b215c01fcfe6eca89c1bc1e82caf667552f6408c5f4534a93341e24313a"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
