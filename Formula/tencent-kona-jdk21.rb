class TencentKonaJdk21 < Formula
  desc "Tencent Kona - Tencent's distribution of OpenJDK"
  homepage "https://cloud.tencent.com/product/tkjdk"
  version "TencentKona-21.0.12"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Tencent/TencentKona-21/releases/download/TencentKona-21.0.12/TencentKona-21.0.12.b1_jdk_macosx-aarch64_notarized.tar.gz"
      sha256 "cfbfee68e8236adee8006e8816b1aa98a59d0ae7a2db276ae475a4fa7fbfdf8c"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-21/releases/download/TencentKona-21.0.12/TencentKona-21.0.12.b1_jdk_macosx-x86_64_notarized.tar.gz"
      sha256 "4032c58da90fc6aae8dedeb7236003798606ed830fededfe98512c525309763c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Tencent/TencentKona-21/releases/download/TencentKona-21.0.12/TencentKona-21.0.12.b1-jdk_linux-aarch64.tar.gz"
      sha256 "7594bf9c6c6aae8826dd9335479ddcc9a2c760ae693e61f1ec65b8c1247f8c76"
    end
    on_intel do
      url "https://github.com/Tencent/TencentKona-21/releases/download/TencentKona-21.0.12/TencentKona-21.0.12.b1-jdk_linux-x86_64.tar.gz"
      sha256 "22ee6933c7110af5814edcdae25c85605cf7dd08f94419b7c6fa9ff7f0065f2e"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
