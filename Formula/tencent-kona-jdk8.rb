class TencentKonaJdk8 < Formula
  desc "Tencent Kona JDK 8 - Tencent's distribution of OpenJDK"
  homepage "https://cloud.tencent.com/product/tkjdk"
  version "8.0.28-GA"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Tencent/TencentKona-8/releases/download/8.0.28-GA/TencentKona8.0.28.b1_jdk_linux-aarch64_8u512.tar.gz"
      sha256 "77a0650eb04038473f56e4784a9b5d8e7121c0b4935ebd75bd5ed7f8cb156fb1"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-8/releases/download/8.0.28-GA/TencentKona8.0.28.b1_jdk_linux-aarch64_8u512.tar.gz"
      sha256 "77a0650eb04038473f56e4784a9b5d8e7121c0b4935ebd75bd5ed7f8cb156fb1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Tencent/TencentKona-8/releases/download/8.0.28-GA/TencentKona8.0.28.b1_jdk_linux-aarch64_8u512.tar.gz"
      sha256 "77a0650eb04038473f56e4784a9b5d8e7121c0b4935ebd75bd5ed7f8cb156fb1"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-8/releases/download/8.0.28-GA/TencentKona8.0.28.b1_jdk_linux-aarch64_8u512.tar.gz"
      sha256 "77a0650eb04038473f56e4784a9b5d8e7121c0b4935ebd75bd5ed7f8cb156fb1"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
