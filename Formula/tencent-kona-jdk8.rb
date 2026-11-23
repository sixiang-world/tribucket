class TencentKonaJdk8 < Formula
  desc "Tencent Kona JDK 8 - Tencent's distribution of OpenJDK"
  homepage "https://cloud.tencent.com/product/tkjdk"
  version "8.0.29-GA"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Tencent/TencentKona-8/releases/download/8.0.29-GA/TencentKona8.0.29.b1_jdk_linux-aarch64_8u514.tar.gz"
      sha256 "69af4f6138914d222e8ce307a61946ab553e4dc36a12f6ce260ffbef640a38fa"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-8/releases/download/8.0.29-GA/TencentKona8.0.29.b1_jdk_linux-aarch64_8u514.tar.gz"
      sha256 "69af4f6138914d222e8ce307a61946ab553e4dc36a12f6ce260ffbef640a38fa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Tencent/TencentKona-8/releases/download/8.0.29-GA/TencentKona8.0.29.b1_jdk_linux-aarch64_8u514.tar.gz"
      sha256 "69af4f6138914d222e8ce307a61946ab553e4dc36a12f6ce260ffbef640a38fa"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-8/releases/download/8.0.29-GA/TencentKona8.0.29.b1_jdk_linux-aarch64_8u514.tar.gz"
      sha256 "69af4f6138914d222e8ce307a61946ab553e4dc36a12f6ce260ffbef640a38fa"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
