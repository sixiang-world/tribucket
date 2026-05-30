class TencentKonaJdk8 < Formula
  desc "Tencent Kona JDK 8 - Tencent's distribution of OpenJDK"
  homepage "https://cloud.tencent.com/product/tkjdk"
  version "8.0.26-GA"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Tencent/TencentKona-8/releases/download/8.0.26-GA/TencentKona8.0.26.b1_jdk_linux-aarch64_8u492.tar.gz"
      sha256 "4928cbe8cb7c393c1b8dc94a2453afa6682dd372d64d445930b7f3808a31ffad"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-8/releases/download/8.0.26-GA/TencentKona8.0.26.b1_jdk_linux-aarch64_8u492.tar.gz"
      sha256 "4928cbe8cb7c393c1b8dc94a2453afa6682dd372d64d445930b7f3808a31ffad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Tencent/TencentKona-8/releases/download/8.0.26-GA/TencentKona8.0.26.b1_jdk_linux-aarch64_8u492.tar.gz"
      sha256 "4928cbe8cb7c393c1b8dc94a2453afa6682dd372d64d445930b7f3808a31ffad"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-8/releases/download/8.0.26-GA/TencentKona8.0.26.b1_jdk_linux-aarch64_8u492.tar.gz"
      sha256 "4928cbe8cb7c393c1b8dc94a2453afa6682dd372d64d445930b7f3808a31ffad"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
