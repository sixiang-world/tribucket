class TencentKonaJdk8 < Formula
  desc "Tencent Kona JDK 8 - Tencent's distribution of OpenJDK"
  homepage "https://cloud.tencent.com/product/tkjdk"
  version "8.0.27-GA"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Tencent/TencentKona-8/releases/download/8.0.27-GA/TencentKona8.0.27.b1_jdk_linux-aarch64_8u502.tar.gz"
      sha256 "881a945775f29a1c3bb242bb0340f7d40a298f3e38fed1c389cd88738c9cab27"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-8/releases/download/8.0.27-GA/TencentKona8.0.27.b1_jdk_linux-aarch64_8u502.tar.gz"
      sha256 "881a945775f29a1c3bb242bb0340f7d40a298f3e38fed1c389cd88738c9cab27"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Tencent/TencentKona-8/releases/download/8.0.27-GA/TencentKona8.0.27.b1_jdk_linux-aarch64_8u502.tar.gz"
      sha256 "881a945775f29a1c3bb242bb0340f7d40a298f3e38fed1c389cd88738c9cab27"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-8/releases/download/8.0.27-GA/TencentKona8.0.27.b1_jdk_linux-aarch64_8u502.tar.gz"
      sha256 "881a945775f29a1c3bb242bb0340f7d40a298f3e38fed1c389cd88738c9cab27"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
