class TencentKonaJdk17 < Formula
  desc "Tencent Kona JDK 17 - Tencent's distribution of OpenJDK"
  homepage "https://cloud.tencent.com/product/tkjdk"
  version "TencentKona-17.0.21.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Tencent/TencentKona-17/releases/download/TencentKona-17.0.21.1/TencentKona-17.0.21.1.b1-jdk_linux-aarch64.tar.gz"
      sha256 "03ef7197ba6a066bca0b49186782ac0aa90466800770a9525a5c1a76e3b4a5ed"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-17/releases/download/TencentKona-17.0.21.1/TencentKona-17.0.21.1.b1-jdk_linux-aarch64.tar.gz"
      sha256 "03ef7197ba6a066bca0b49186782ac0aa90466800770a9525a5c1a76e3b4a5ed"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Tencent/TencentKona-17/releases/download/TencentKona-17.0.21.1/TencentKona-17.0.21.1.b1-jdk_linux-aarch64.tar.gz"
      sha256 "03ef7197ba6a066bca0b49186782ac0aa90466800770a9525a5c1a76e3b4a5ed"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-17/releases/download/TencentKona-17.0.21.1/TencentKona-17.0.21.1.b1-jdk_linux-aarch64.tar.gz"
      sha256 "03ef7197ba6a066bca0b49186782ac0aa90466800770a9525a5c1a76e3b4a5ed"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
